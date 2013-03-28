# Redis stores for Ruby frameworks

__Redis Store__ provides a full set of stores (*Cache*, *I18n*, *Session*, *HTTP Cache*) for all the modern Ruby frameworks like: __Ruby on Rails__, __Sinatra__, __Rack__, __Rack::Cache__ and __I18n__. It natively supports object marshalling, timeouts, single or multiple nodes and namespaces.

See the main [redis-store readme](https://github.com/jodosha/redis-store) for general guidelines.

If you are using redis-store with Rails, consider using the [redis-rails gem](https://github.com/jodosha/redis-store/tree/master/redis-rails) instead.

## Running tests

    gem install bundler
    git clone git://github.com/jodosha/redis-store.git
    cd redis-store/redis-store
    ruby ci/run.rb

If you are on **Snow Leopard** you have to run `env ARCHFLAGS="-arch x86_64" ruby ci/run.rb`

## Configuring Redis Store

### Changing storage strategies

Several months ago Matt Huggins (https://github.com/mhuggins) introduced a change to the redis-store gem to decouple how it marshals data into the redis database. Normally, data is marshalled using Ruby's Marshal class. This strategy is fine when access to the data is only given to Ruby-based application but not for any other kind of application unless it has implemented its own Ruby Marshal parser. With this change, a more universal marshal strategy can be applied like JSON. There are caveats to using different strategies such as JSON not serializing Ruby objects properly so make sure that you are using the strategy that fits your needs.

Example usage:

Each of the following will create a new redis store object that uses the new Marshal adapter

    Redis::Store.new
    Redis::Store.new(:strategy => :marshal)  # symbol shorthand
    Redis::Store.new(:strategy => Redis::Store::Strategy::Marshal)  # actual class
    Redis::Store.new(:strategy => "Redis::Store::Strategy::Marshal")  # string name representing class

Each of the following will create a new redis store object that uses the new Json adapter

    Redis::Store.new(:strategy => :json)   # symbol shorthand
    Redis::Store.new(:strategy => Redis::Store::Strategy::Json)  # actual class
    Redis::Store.new(:strategy => "Redis::Store::Strategy::Json")  # string name representing class

Creating a strategy:

A new strategy simply has to be able to perform two methods: _dump and _load.

    module RedisYamlAdapter
      def self._dump(object)
        ::YAML.dump(object)
      end

      def self._load(string)
        ::YAML.load(string)
      end
    end

    Redis::Store.new(:adapter => RedisYamlAdapter)

## Copyright

(c) 2009 - 2011 Luca Guidi - [http://lucaguidi.com](http://lucaguidi.com), released under the MIT license
