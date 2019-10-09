require "active_support/core_ext/object/inclusion"

# A set of transformations that can be applied to a blob to create a variant. This class is exposed via 
# the `BackupStorage::Blob#variant` method and should rarely be used directly.
#
# In case you do need to use this directly, it's instantiated using a hash of transformations where
# the key is the command and the value is the arguments. Example:
#
#   BackupStorage::Variation.new(resize: "100x100", monochrome: true, trim: true, rotate: "-90")
#
# A list of all possible transformations is available at https://www.imagemagick.org/script/mogrify.php.
class BackupStorage::Variation
  attr_reader :transformations

  class << self
    # Returns a variation instance with the transformations that were encoded by `#encode`.
    def decode(key)
      new BackupStorage.verifier.verify(key, purpose: :variation)
    end

    # Returns a signed key for the `transformations`, which can be used to refer to a specific
    # variation in a URL or combined key (like `BackupStorage::Variant#key`).
    def encode(transformations)
      BackupStorage.verifier.generate(transformations, purpose: :variation)
    end
  end

  def initialize(transformations)
    @transformations = transformations
  end

  # Accepts an open MiniMagick image instance, like what's return by `MiniMagick::Image.read(io)`,
  # and performs the `transformations` against it. The transformed image instance is then returned.
  def transform(image)
    transformations.each do |(method, argument)|
      if eligible_argument?(argument)
        image.public_send(method, argument)
      else
        image.public_send(method)
      end
    end
  end

  # Returns a signed key for all the `transformations` that this variation was instantiated with.
  def key
    self.class.encode(transformations)
  end

  private
    def eligible_argument?(argument)
      argument.present? && argument != true
    end
end
