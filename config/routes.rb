Rails.application.routes.draw do
  # get "/rails/backup_storage/blobs/:signed_id/*filename" => "backup_storage/blobs#show", as: :rails_service_blob

  # direct :rails_blob do |blob|
  #   route_for(:rails_service_blob, blob.signed_id, blob.filename)
  # end

  # resolve("BackupStorage::Blob")       { |blob| route_for(:rails_blob, blob) }
  # resolve("BackupStorage::Attachment") { |attachment| route_for(:rails_blob, attachment.blob) }


  # get  "/rails/backup_storage/variants/:signed_blob_id/:variation_key/*filename" => "backup_storage/variants#show", as: :rails_blob_variation

  # direct :rails_variant do |variant|
  #   signed_blob_id = variant.blob.signed_id
  #   variation_key  = variant.variation.key
  #   filename       = variant.blob.filename

  #   route_for(:rails_blob_variation, signed_blob_id, variation_key, filename)
  # end

  # resolve("BackupStorage::Variant") { |variant| route_for(:rails_variant, variant) }


  # get  "/rails/backup_storage/disk/:encoded_key/*filename" => "backup_storage/disk#show", as: :rails_disk_service
  # put  "/rails/backup_storage/disk/:encoded_token" => "backup_storage/disk#update", as: :update_rails_disk_service
  # post "/rails/backup_storage/direct_uploads" => "backup_storage/direct_uploads#create", as: :rails_direct_uploads
end
