# == Schema Information
#
# Table name: users
#
#  id         :integer(4)      not null, primary key
#  username   :string(255)
#  password   :string(255)
#  email      :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :username, :password, :password_confirmation, :email, :name

  validates :username,            :presence => true,
                                  :length => { :maximum => 50 },
                                  :uniqueness => { :case_sensitive => false }
  validates :password,            :presence => true,
                                  :confirmation => true,
                                  :length => { :within => 6..50 }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,    :presence => true,
                       :length => { :maximum => 100 },
                       :format => { :with => email_regex }
  validates :name,     :presence => true,
                       :length => { :maximum => 50 }

  before_save :encrypt_password

  # Returns true if the user's password matches the submitted password
  def has_password?(submitted_password)
    # Compare encrypted password with the encrypted version of submitted_password
    encrypted_password == encrypt(submitted_password)
  end

  # Checks if the submitted username and password are a valid combination
  # If the user exists, the user entity is returned
  # Else, nil is returned
  def self.authenticate(username, submitted_password)
    user = find_by_username(username)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  private
    def encrypt_password
      # must use self.encrypted_password, otherwise Ruby will create local var
      # don't have to use self.password for param to encrypt
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      # Current implementation: one-way hash with sha2 and a salt of current UTC
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
