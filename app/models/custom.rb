class Custom < ActiveRecord::Base

  belongs_to :organization

  # Root directory of the photo public/photos
  PHOTO_STORE = "#{Rails.root}/public/files/organizations/logos/"

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
