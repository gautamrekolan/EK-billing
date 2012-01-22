class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "is not a valid email address") unless
      value =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  end
end

class Customer < ActiveRecord::Base
  belongs_to  :organization
  has_many    :autos,         :dependent => :delete_all, :order => "start_date asc"
  has_many    :documents,     :dependent => :delete_all, :order => "description asc"
  has_many    :horses,        :dependent => :delete_all, :order => "barn_name asc"
  has_many    :invoices,      :dependent => :delete_all, :order => "end_date desc"

  validates :first_name,      :presence => true, :length => { :maximum => 50 }
  validates :last_name,       :presence => true, :length => { :maximum => 50 }
  validates :address,         :presence => true, :length => { :maximum => 50 }
  validates :city,            :presence => true, :length => { :maximum => 50 }
  validates :state,           :presence => true, :length => { :maximum => 2 }
  validates :zip,             :presence => true, :length => { :maximum => 10 }
  validates :home,            :length => { :minimum => 10, :maximum => 25 }, :format => { :with => /\A\S[0-9\+\/\(\)\s\-]*\z/i }
  validates :cell,            :length => { :minimum => 10, :maximum => 25 }, :format => { :with => /\A\S[0-9\+\/\(\)\s\-]*\z/i }
  validates :work,            :length => { :minimum => 10, :maximum => 25 }, :format => { :with => /\A\S[0-9\+\/\(\)\s\-]*\z/i }
  validates :email,           :email => true, :length => { :maximum => 250 }, :if => :email?
  #validates :active
  #validates :delivery_method
  #validates :auto_invoice
  validates :organization_id, :presence => true, :numericality => true

  def email?()
    if self.email.blank? == false
      true
    end
    false
  end


end
