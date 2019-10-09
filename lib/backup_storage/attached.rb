require "backup_storage/blob"
require "backup_storage/attachment"

require "action_dispatch/http/upload"
require "active_support/core_ext/module/delegation"

# Abstract baseclass for the concrete `BackupStorage::Attached::One` and `BackupStorage::Attached::Many`
# classes that both provide proxy access to the blob association for a record.
class BackupStorage::Attached
  attr_reader :name, :record

  def initialize(name, record)
    @name, @record = name, record
  end

  private
    def create_blob_from(attachable)
      case attachable
      when BackupStorage::Blob
        attachable
      when ActionDispatch::Http::UploadedFile
        BackupStorage::Blob.create_after_upload! \
          io: attachable.open,
          filename: attachable.original_filename,
          content_type: attachable.content_type
      when Hash
        BackupStorage::Blob.create_after_upload!(attachable)
      when String
        BackupStorage::Blob.find_signed(attachable)
      else
        nil
      end
    end
end

require "backup_storage/attached/one"
require "backup_storage/attached/many"
require "backup_storage/attached/macros"
