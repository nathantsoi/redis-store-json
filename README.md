# Rails 4 Redis session store with JSON serialization

Require store and actionpack

```
gem 'redis-actionpack-json', '~> 4.0.0'
gem 'redis-rack', '~> 1.5.2'
gem 'redis-store', '~> 3.0.0'
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
