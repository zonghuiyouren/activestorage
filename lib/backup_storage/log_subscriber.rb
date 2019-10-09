require "active_support/log_subscriber"

class BackupStorage::LogSubscriber < ActiveSupport::LogSubscriber
  def service_upload(event)
    message = "Uploaded file to key: #{key_in(event)}"
    message << " (checksum: #{event.payload[:checksum]})" if event.payload[:checksum]
    info event, color(message, GREEN)
  end

  def service_download(event)
    info event, color("Downloaded file from key: #{key_in(event)}", BLUE)
  end

  def service_delete(event)
    info event, color("Deleted file from key: #{key_in(event)}", RED)
  end

  def service_exist(event)
    debug event, color("Checked if file exist at key: #{key_in(event)} (#{event.payload[:exist] ? "yes" : "no"})", BLUE)
  end

  def service_url(event)
    debug event, color("Generated URL for file at key: #{key_in(event)} (#{event.payload[:url]})", BLUE)
  end

  def logger
    BackupStorage::Service.logger
  end

  private
    def info(event, colored_message)
      super log_prefix_for_service(event) + colored_message
    end

    def debug(event, colored_message)
      super log_prefix_for_service(event) + colored_message
    end

    def log_prefix_for_service(event)
      color "  #{event.payload[:service]} Storage (#{event.duration.round(1)}ms) ", CYAN
    end

    def key_in(event)
      event.payload[:key]
    end
end

BackupStorage::LogSubscriber.attach_to :backup_storage
