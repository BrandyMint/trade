class DocumentUploader < ImageUploader
  EXTENSION_WHITE_LIST = %w(jpg jpeg gif png tiff).freeze
  #IMAGE_EXTENSIONS = %w(jpg jpeg gif png tiff).freeze

  #version :thumb do
    #process resize_to_fill: [64, 64]
  #end

  #def image?
    #IMAGE_EXTENSIONS.include? extension
  #end
end
