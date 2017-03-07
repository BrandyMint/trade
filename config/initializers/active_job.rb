Rails.application.config.active_job.queue_adapter = :inline unless Rails.env.production?
