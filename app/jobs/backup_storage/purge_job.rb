# Provides delayed purging of attachments or blobs using their `#purge_later` method.
class BackupStorage::PurgeJob < ActiveJob::Base
  # FIXME: Limit this to a custom BackupStorage error
  retry_on StandardError

  def perform(attachment_or_blob)
    attachment_or_blob.purge
  end
end
