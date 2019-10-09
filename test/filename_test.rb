require "test_helper"

class BackupStorage::FilenameTest < ActiveSupport::TestCase
  test "sanitize" do
    "%$|:;/\t\r\n\\".each_char do |character|
      filename = BackupStorage::Filename.new("foo#{character}bar.pdf")
      assert_equal "foo-bar.pdf", filename.sanitized
      assert_equal "foo-bar.pdf", filename.to_s
    end
  end

  test "sanitize transcodes to valid UTF-8" do
    { "\xF6".force_encoding(Encoding::ISO8859_1) => "ö",
      "\xC3".force_encoding(Encoding::ISO8859_1) => "Ã",
      "\xAD" => "�",
      "\xCF" => "�",
      "\x00" => "",
    }.each do |actual, expected|
      assert_equal expected, BackupStorage::Filename.new(actual).sanitized
    end
  end

  test "strips RTL override chars used to spoof unsafe executables as docs" do
    # Would be displayed in Windows as "evilexe.pdf" due to the right-to-left
    # (RTL) override char!
    assert_equal "evil-fdp.exe", BackupStorage::Filename.new("evil\u{202E}fdp.exe").sanitized
  end

  test "compare case-insensitively" do
    assert_operator BackupStorage::Filename.new("foobar.pdf"), :==, BackupStorage::Filename.new("FooBar.PDF")
  end

  test "compare sanitized" do
    assert_operator BackupStorage::Filename.new("foo-bar.pdf"), :==, BackupStorage::Filename.new("foo\tbar.pdf")
  end
end
