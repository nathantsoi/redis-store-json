require 'test_helper'

# For faking rails flash objects retrieved from session
module FakeActionDispatch
  class Flash
    class FlashHash < Hash
    end
  end
end

describe "Redis::Store::Strategy::JsonSession" do
  def setup
    @marshal_store = Redis::Store.new :strategy => :marshal
    @store = Redis::Store.new :strategy => :json_session
    @rabbit = {:name => "rabbit", :legs => 4}
    @peter     = { :name => "Peter Cottontail",
                   :race => @rabbit }
    @bunnicula = { :name    => "Bunnicula",
                   :race    => @rabbit,
                   :friends => [@peter],
                   :age     => 3.1,
                   :alive   => true }
    @store.set "rabbit", @bunnicula
    @store.del "rabbit2"
  end

  def teardown
    @store.quit
  end

  it "unmarshals on get" do
    @store.get("rabbit").must_equal(@bunnicula)
  end

  it "marshals on set" do
    @store.set "rabbit", @peter
    @store.get("rabbit").must_equal(@peter)
  end

  it "doesn't unmarshal on get if raw option is true" do
    race = @rabbit.to_json
    @store.get("rabbit", :raw => true).must_equal(%({"name":"Bunnicula","race":#{race},"friends":[{"name":"Peter Cottontail","race":#{race}}],"age":3.1,"alive":true}))
  end

  it "doesn't marshal on set if raw option is true" do
    race = @rabbit
    @store.set "rabbit", @peter, :raw => true
    @store.get("rabbit", :raw => true).must_equal(%({:name=>"Peter Cottontail", :race=>#{race.inspect}}))
  end

  it "doesn't set an object if already exist" do
    @store.setnx "rabbit", @peter
    @store.get("rabbit").must_equal(@bunnicula)
  end

  it "marshals on set unless exists" do
    @store.setnx "rabbit2", @peter
    @store.get("rabbit2").must_equal(@peter)
  end

  it "doesn't marshal on set unless exists if raw option is true" do
    @store.setnx "rabbit2", @peter, :raw => true
    race = @rabbit
    @store.get("rabbit2", :raw => true).must_equal(%({:name=>"Peter Cottontail", :race=>#{race.inspect}}))
  end

  it "doesn't unmarshal on multi get" do
    @store.set "rabbit2", @peter
    rabbit, rabbit2 = @store.mget "rabbit", "rabbit2"
    rabbit.must_equal(@bunnicula)
    rabbit2.must_equal(@peter)
  end

  it "doesn't unmarshal on multi get if raw option is true" do
    @store.set "rabbit", @bunnicula
    @store.set "rabbit2", @peter
    rabbit, rabbit2 = @store.mget "rabbit", "rabbit2", :raw => true
    race = @rabbit.to_json
    rabbit.must_equal(%({"name":"Bunnicula","race":#{race},"friends":[{"name":"Peter Cottontail","race":#{race}}],"age":3.1,"alive":true}))
    rabbit2.must_equal(%({"name":"Peter Cottontail","race":#{race}}))
  end

  it "will throw an error if an object isn't supported" do
    lambda{
      @store.set "rabbit2", OpenStruct.new(foo:'bar')
    }.must_raise Redis::Store::Strategy::JsonSession::SerializationError
  end

  it "is able to bring out data that is marshalled using Ruby" do
    @marshal_store.set "rabbit", @peter
    rabbit = @store.get "rabbit"
    rabbit.must_equal(@peter)
  end

  it "can set a Set object" do
    @store.set "set_object", Set.new([1,2])
    set_object = @store.get("set_object")
    set_object.must_equal([1,2])
  end

  describe "flash key value" do

    before do
      @flash_value = {:show_login => true }
      @flash_data = {:flash => @flash_value}
    end

    describe "when ActionDispatch is available" do

      before do
        ActionDispatch = FakeActionDispatch
        @store.class.send(:include, ActionDispatch)
      end

      it "returns a flash object instead of a hash" do
        @store.set "flash", @flash_data
        flash_store = @store.get "flash"
        flash_hash = flash_store[:flash]
        flash_hash.class.must_equal(FakeActionDispatch::Flash::FlashHash)
        flash_hash.must_equal(@flash_value)
      end

    end

    it "returns a hash" do
      @store.set "flash", @flash_data
      flash = @store.get "flash"
      flash.must_equal(@flash_data)
    end

  end

  describe "binary safety" do
    before do
      @utf8_key = [51339].pack("U*")
      @ascii_string = [128].pack("C*")
      @ascii_rabbit = {:name => "rabbit", :legs => 4, :ascii_string => @ascii_string}
    end

    it "gets and sets raw values" do
      @store.set(@utf8_key, @ascii_string, :raw => true)
      @store.get(@utf8_key, :raw => true).bytes.to_a.must_equal(@ascii_string.bytes.to_a)
    end

    it "marshals objects on setnx" do
      @store.del(@utf8_key)
      @store.setnx(@utf8_key, @ascii_rabbit)
      retrievied_ascii_rabbit = @store.get(@utf8_key)
      JSON.load(JSON.generate(retrievied_ascii_rabbit.delete(:ascii_string))).must_equal(@ascii_string)
      @ascii_rabbit.delete(:ascii_string)
      retrievied_ascii_rabbit.must_equal(@ascii_rabbit)
    end

    it "gets and sets raw values on setnx" do
      @store.del(@utf8_key)
      @store.setnx(@utf8_key, @ascii_string, :raw => true)
      @store.get(@utf8_key, :raw => true).bytes.to_a.must_equal(@ascii_string.bytes.to_a)
    end
  end if defined?(Encoding)
end
