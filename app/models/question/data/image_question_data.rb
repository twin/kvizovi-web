require_relative "text_question_data"
require "paperclip"
require "uri"

class ImageQuestionData < TextQuestionData
  self.table_name = "image_question_data"

  attr_accessor :image_url, :image_file
  attr_accessible :image_url, :image_file, :image

  after_initialize :assign_image

  include Paperclip::Glue
  has_attached_file :image, styles: {resized: "x250>"}

  validates_format_of :image_url, with: URI.regexp, allow_blank: true
  validates :image, attachment_presence: true

  private

  def assign_image
    if image_file.present?
      self.image = image_file
    elsif image_url.present?
      begin
        self.image = URI.parse(image_url)
      rescue
      end
    end
  end
end