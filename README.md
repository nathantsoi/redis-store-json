# Rails 4 Redis session store with JSON serialization

Require store, actionpack and rack

```
gem 'redis-actionpack-json', github: 'nathantsoi/redis-store-json'
gem 'redis-store-json', github: 'nathantsoi/redis-store-json'
gem 'redis-rack-json', github: 'nathantsoi/redis-store-json'
```

Configure the session

```
MyApplication.config.session_store :redis_store,
  :key        => '_session_key',
  :key_prefix => 'key_prefix_',
  :strategy   => :json_session,
  :domain     => :all,
  :server     => {
    :host       => :localhost,
    :port       => 6379
  }
```
