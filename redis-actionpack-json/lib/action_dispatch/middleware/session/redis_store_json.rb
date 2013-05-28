require 'redis-store-json'
require 'redis-rack-json'
require 'action_dispatch/middleware/session/abstract_store'

module ActionDispatch
  module Session
    class RedisStoreJson < Rack::Session::Redis
      include Compatibility
      include StaleSessionCheck
      def initialize(app, options = {})
        options = options.dup
        options[:redis_server] ||= options[:servers] if options[:servers].present?
        super
      end

      private

      def set_cookie(env, session_id, cookie)
        request = ActionDispatch::Request.new(env)
        request.cookie_jar[key] = cookie
      end
    end
  end
end
