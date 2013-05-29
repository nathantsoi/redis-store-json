# Rails 4 Redis session store with JSON serialization

Require store, actionpack and rack

```
gem 'redis-actionpack-json', github: 'nathantsoi/redis-store-json'
gem 'redis-store-json', github: 'nathantsoi/redis-store-json'
gem 'redis-rack-json', github: 'nathantsoi/redis-store-json'
```

Configure the session

```
MyAppName::Application.config.session_store :redis_store_json,
  key: "_my_app_session",
  strategy: :json_session,
  domain: :all,
  servers: {
    host: :localhost,
    port: 6379
  }
```
