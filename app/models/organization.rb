class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "is not a valid email address") unless
      value =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  end
end

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "is not a valid website address") unless
      value =~ /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
  end
end

class Organization < ActiveRecord::Base

  has_many  :users
  has_many  :customers
  has_one   :custom
  has_many  :horses
  has_many  :invoices

  validates :name,      :presence => true, :length => { :maximum => 250 }
  validates :address,   :presence => true, :length => { :maximum => 250 }
  validates :city,      :presence => true, :length => { :maximum => 250 }
  validates :state,     :presence => true, :length => { :maximum => 2 }
  validates :zip,       :presence => true, :length => { :maximum => 10 }
  validates :phone,     :presence => true, :length => { :minimum => 10, :maximum => 25 }, :format => { :with => /\A\S[0-9\+\/\(\)\s\-]*\z/i }
  validates :email,     :email => true, :length => { :maximum => 250 }, :if => :email?
  validates :website,   :url => true, :length => { :maximum => 250 }, :if => :website?
  validates :contact,   :presence => true, :length => { :maximum => 250 }

  def email?()
    if self.email.blank? == false
      true
    end
    false
  end

  def website?()
    if self.website.blank? == false
      true
    end
    false
  end

end
