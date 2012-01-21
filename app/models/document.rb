class Document < ActiveRecord::Base

  belongs_to :organization
  belongs_to  :customer
  belongs_to  :horse

  validates :description,    :presence => true
  validates :extension,      :inclusion => { :in => %w(pdf jpg jpeg gif png bmp), :message => "should be of type .jpg, .jpeg, .gif, .png, .bmp or .pdf." }

  # Root directory of the photo public/photos
  PHOTO_STORE = "#{Rails.root}/public/files/documents/"

  def self.save_image(id, ext, data)
    if data
      filename_ext = id.to_s + "." + ext
      filename = File.join PHOTO_STORE, filename_ext
      File.open(filename, 'wb') do |f|
        f.write(data.read)
      end
    end
  end

end
