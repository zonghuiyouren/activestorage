require "service/shared_service_tests"

class BackupStorage::Service::DiskServiceTest < ActiveSupport::TestCase
  SERVICE = BackupStorage::Service::DiskService.new(root: File.join(Dir.tmpdir, "backup_storage"))

  include BackupStorage::Service::SharedServiceTests

  test "url generation" do
    assert_match /rails\/backup_storage\/disk\/.*\/avatar\.png\?.+disposition=inline/,
      @service.url(FIXTURE_KEY, expires_in: 5.minutes, disposition: :inline, filename: "avatar.png", content_type: "image/png")
  end
end
