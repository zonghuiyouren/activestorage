class BackupStorage::Service::Configurator #:nodoc:
  attr_reader :configurations

  def self.build(service_name, configurations)
    new(configurations).build(service_name)
  end

  def initialize(configurations)
    @configurations = configurations.deep_symbolize_keys
  end

  def build(service_name)
    config = config_for(service_name.to_sym)
    resolve(config.fetch(:service)).build(**config, configurator: self)
  end

  private
    def config_for(name)
      configurations.fetch name do
        raise "Missing configuration for the #{name.inspect} Backup Storage service. Configurations available for #{configurations.keys.inspect}"
      end
    end

    def resolve(class_name)
      require "backup_storage/service/#{class_name.to_s.downcase}_service"
      BackupStorage::Service.const_get(:"#{class_name}Service")
    end
end
