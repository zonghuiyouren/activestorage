require "rails/engine"

module BackupStorage
  class Engine < Rails::Engine # :nodoc:
    config.backup_storage = ActiveSupport::OrderedOptions.new

    config.eager_load_namespaces << BackupStorage

    initializer "backup_storage.logger" do
      require "backup_storage/service"

      config.after_initialize do |app|
        BackupStorage::Service.logger = app.config.backup_storage.logger || Rails.logger
      end
    end

    initializer "backup_storage.attached" do
      require "backup_storage/attached"

      ActiveSupport.on_load(:active_record) do
        extend BackupStorage::Attached::Macros
      end
    end

    initializer "backup_storage.verifier" do
      config.after_initialize do |app|
        BackupStorage.verifier = app.message_verifier("BackupStorage")
      end
    end

    initializer "backup_storage.services" do
      config.after_initialize do |app|
        if config_choice = app.config.backup_storage.service
          config_file = Pathname.new(Rails.root.join("config/storage_services.yml"))
          raise("Couldn't find Backup Storage configuration in #{config_file}") unless config_file.exist?

          require "yaml"
          require "erb"

          configs =
            begin
              YAML.load(ERB.new(config_file.read).result) || {}
            rescue Psych::SyntaxError => e
              raise "YAML syntax error occurred while parsing #{config_file}. " \
                    "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
                    "Error: #{e.message}"
            end

          BackupStorage::Blob.service =
            begin
              BackupStorage::Service.configure config_choice, configs
            rescue => e
              raise e, "Cannot load `Rails.config.backup_storage.service`:\n#{e.message}", e.backtrace
            end
        end
      end
    end
  end
end
