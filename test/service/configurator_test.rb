require "service/shared_service_tests"

class BackupStorage::Service::ConfiguratorTest < ActiveSupport::TestCase
  test "builds correct service instance based on service name" do
    service = BackupStorage::Service::Configurator.build(:foo, foo: { service: "Disk", root: "path" })
    assert_instance_of BackupStorage::Service::DiskService, service
  end

  test "raises error when passing non-existent service name" do
    assert_raise RuntimeError do
      BackupStorage::Service::Configurator.build(:bigfoot, {})
    end
  end
end
