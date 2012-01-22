class Document < ActiveRecord::Base

  belongs_to :organization
  belongs_to  :customer
  belongs_to  :horse

  validates :description,     :presence => true, :length => { :maximum => 250 }
  validates :notes,           :length => { :maximum => 250 }
  validates :extension,       :inclusion => { :in => %w(pdf jpg jpeg gif png bmp), :message => "should be of type .jpg, .jpeg, .gif, .png, .bmp or .pdf." }
  validates :organization_id, :presence => true, :numericality => true
  validates :customer_id,     :numericality => true, :if => :customer?
  validates :horse_id,        :numericality => true, :if => :horse?

  def customer?()
    if self.customer_id.blank? == false
      true
    else
      false
    end
  end

  def horse?()
    if self.horse_id.blank? == false
      true
    else
      false
    end
  end

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
