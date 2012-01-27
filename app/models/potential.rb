class SafeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "is not a valid email address") unless
      value =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  end
end

class Potential < ActiveRecord::Base

  validates :email, :presence   => { :message => "Please enter a valid email address." }
  #validates :email, :safe       => { :message => "Please enter a valid email address." }
  validates :email, :uniqueness => { :message => "That email address has already been entered." }

end
