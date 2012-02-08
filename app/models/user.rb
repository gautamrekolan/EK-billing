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
  belongs_to :organization
  belongs_to :customer

  attr_accessor :password, :update_password
  attr_accessible :username, :temp_password, :password, :password_confirmation, :update_password, :email, :name, :access, :organization_id

  validates :username, :presence => true,
                       :length => { :maximum => 50 },
                       :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..50 },
                       :if => :update_password?

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,    :presence => true,
                       :length => { :maximum => 100 },
                       :format => { :with => email_regex }
  validates :name,     :presence => true,
                       :length => { :maximum => 50 }

  before_save :encrypt_password

  def update_password?()
    if self.update_password
      true
    end
    false
  end

  # Returns true if the user's password matches the submitted password
  def has_password?(submitted_password)
    # Compare encrypted password with the encrypted version of submitted_password
    if encrypted_password.blank? == false
      encrypted_password == encrypt(submitted_password)
    else
      temp_password == submitted_password
    end
  end

  # Generates a random string from a set of easily readable characters
  def self.generate_random_pwd(size = 10)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end

  def self.create_customer_acct(customer)
    @user = User.new
    @user.username = customer.email
    @user.email= customer.email
    @user.name = customer.first_name + " " + customer.last_name
    @user.access = "customer"
    @user.update_password = false
    @user.temp_password = generate_random_pwd(10)
    @user.encrypted_password = nil
    @user.salt = nil
    @user.organization_id = customer.organization_id
    @user.customer_id = customer.id
    if @user.save
      @user
    else
      nil
    end
  end

  def self.create_manager_acct(name, email, organization)
    @user = User.new
    @user.username = email
    @user.email = email
    @user.name = name
    @user.access = "manager"
    @user.update_password = false
    @user.temp_password = generate_random_pwd(10)
    @user.encrypted_password = nil
    @user.salt = nil
    @user.organization_id = organization
    if @user.save
      @user
    else
      nil
    end
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
      if self.update_password
        # must use self.encrypted_password, otherwise Ruby will create local var
        # don't have to use self.password for param to encrypt
        self.salt = make_salt unless has_password?(password)
        self.encrypted_password = encrypt(password)
      end
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
