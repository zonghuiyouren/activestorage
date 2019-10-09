require "service/shared_service_tests"
require "httparty"
require "uri"

if SERVICE_CONFIGURATIONS[:azure]
  class BackupStorage::Service::AzureServiceTest < ActiveSupport::TestCase
    SERVICE = BackupStorage::Service.configure(:azure, SERVICE_CONFIGURATIONS)

    include BackupStorage::Service::SharedServiceTests
  end

else
  puts "Skipping Azure Storage Service tests because no Azure configuration was supplied"
end
