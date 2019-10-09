require "backup_storage/migration"
require_relative "create_users_migration"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
BackupStorageCreateTables.migrate(:up)
BackupStorageCreateUsers.migrate(:up)
