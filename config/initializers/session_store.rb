# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: '_trade_session'

Rails.application.config.session_store :redis_session_store, {
  key: 'op_session',
  serializer: :hybrid,
  redis: {
    expire_after: 120.minutes,
    key_prefix: 'online_prodaja:session:',
    url: 'redis://localhost:6379/1',
  }
}
