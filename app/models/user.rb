# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  fname           :string(255)
#  lname           :string(255)
#  street          :string(255)
#  plz             :string(255)
#  place           :string(255)
#  country         :string(255)
#  bought_book     :boolean
#  newsletter      :boolean
#  password_digest :string(255)
#  admin           :boolean
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :bought_book, :country, :email, :fname, :lname,
        :newsletter, :place, :plz, :street, :password, :password_confirmation
  has_secure_password

  before_save { self.email.downcase! }
  before_save :create_remember_token

  validates(:fname, presence: true)
  validates(:lname, presence: true)
  # validates(:street, presence: true)
  # validates(:plz, presence: true)
  # validates(:place, presence: true)
  # validates(:country, presence: true)
  # validates(:bought_book, presence: true)
  # validates(:newsletter, presence: true)
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false })


  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
