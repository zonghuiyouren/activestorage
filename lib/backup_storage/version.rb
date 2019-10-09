require_relative "gem_version"

module BackupStorage
  # Returns the version of the currently loaded BackupStorage as a <tt>Gem::Version</tt>
  def self.version
    gem_version
  end
end
