Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.active_support.deprecation = :stderr
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
