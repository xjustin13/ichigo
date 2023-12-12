namespace :log do
  desc 'WRITE TO LOG'
  task(:write=>:environment) do
    log_level = ENV['LOG_LEVEL']
    levels = ['debug', 'info', 'warn', 'error', 'fatal', 'unknown']
    unless levels.include?(log_level)
      raise('LOG_LEVEL must be in [debug, info, warn, error, fatal, unknown]')
    end
    message = ARGV.last
    Rails.logger.send(log_level.to_sym, message)
    task message.to_sym{}
  end
end
