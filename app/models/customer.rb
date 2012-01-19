# == Schema Information
#
# Table name: customers
#
#  id         :integer(4)      not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  address    :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :string(255)
#  phone      :string(255)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class PhoneValidator < ActiveModel::EachValidator

end

class Customer < ActiveRecord::Base
  has_many :horses,    :dependent => :delete_all, :order => "barn_name asc"
  has_many :invoices,  :dependent => :delete_all, :order => "end_date desc"
  has_many :autos,     :dependent => :delete_all, :order => "end_date asc, category_id asc, description"
  has_many :documents, :dependent => :delete_all, :order => "description asc"

  attr_accessible :first_name, :last_name, :address, :city, :state, :zip, :phone, :email, :auto_invoice, :delivery_method, :active, :user_id

  validates :first_name, :presence => true, :length => { :maximum => 50 }
  validates :last_name,  :presence => true, :length => { :maximum => 50 }
  validates :address,    :presence => true, :length => { :maximum => 50 }
  validates :city,       :presence => true, :length => { :maximum => 50 }
  validates :state,      :presence => true, :length => { :maximum => 2 }
  validates :zip,        :presence => true, :length => { :maximum => 5 }, :numericality => true
  validates :phone,      :presence => true, :length => { :minimum => 10, :maximum => 25 }, :format => { :with => /\A\S[0-9\+\/\(\)\s\-]*\z/i }
  # phone validation: http://stackoverflow.com/questions/4553122/only-validate-an-rails3-model-when-an-value-entered
  # validates :email,      :presence => true # TO-DO: Validate email format
end
