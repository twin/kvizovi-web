require "active_support/core_ext/numeric/bytes"
require "active_support/inflector/transliterate"
require "uri"

class ImageQuestion < TextQuestion
  store :data, accessors: [
    :image_file_name,
    :image_content_type,
    :image_file_size,
    :image_updated_at,
    :image_size,
  ]

  has_attached_file :image, styles: {resized: "x250>"}, whiny: false

  validates_attachment :image, presence: {if: -> { image_url.blank? and image_file.blank? }},
    content_type: {content_type: ["image/jpeg", "image/gif", "image/png"], allow_blank: true},
    size: {in: 0..1.megabyte}
  validate :validate_image_url

  before_save :assign_image_sizes

  attr_reader :image_url
  def image_url=(url)
    if url.present?
      begin
        @image_url = url
        self.image = URI.parse(url)
      rescue
        self.image = nil
      end
    end
  end

  attr_reader :image_file
  def image_file=(file)
    if file.present?
      begin
        @image_file = file
        self.image = SanitizedFile.new(file)
      rescue
        self.image = nil
      end
    end
  end

  def image_width(style = :original);  image_size[style][:width];  end
  def image_height(style = :original); image_size[style][:height]; end

  def temp_image
    image.instance_variable_get("@queued_for_write")[:resized]
  end

  def dup
    super.tap do |question|
      question.image_url = self.image.url
    end
  end

  def category
    "image"
  end

  private

  def assign_image_sizes
    self.image_size = image.instance_variable_get("@queued_for_write").inject({}) do |hash, (style, file)|
      geometry = Paperclip::Geometry.from_file(file)
      hash.update(style => {width: geometry.width.to_i, height: geometry.height.to_i})
    end
  end

  def validate_image_url
    if image_url.present? and image.blank?
      errors.add(:image_url, :invalid)
    end
  end
end

class ImageQuestion
  class SanitizedFile < SimpleDelegator
    include ActiveSupport::Inflector

    # Because Paperclip chooses the adapter for uploaded files
    # by looking at the class name
    def self.name
      "UploadedFile"
    end

    def original_filename
      transliterate(__getobj__.original_filename)
    end
  end
end
