# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
    validates :username, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: {message: 'Password cannot be blank'}
    validates :password, length: {minimum: 8, allow_nil: true} 
    after_initialize :ensure_session_token
    
    attr_reader :password
    
    def self.find_by_credentials(user_name, password)
      user = User.find_by(username: user_name)
      return user if user && user.is_password?(password)
      nil
    end
    
    def self.generate_session_token
      SecureRandom::urlsafe_base64(16)
    end
    
    def reset_session_token!
      self.session_token = User.generate_session_token
      self.save!
      self.session_token
    end
    
    def password=(password)
      @password = password
      self.password_digest = BCrypt::Password.create(password)
    end
    
    def is_password?(password)
      pass = BCrypt::Password.new(self.password_digest)
      pass.is_password?(password)
    end
    
    private
    
    def ensure_session_token
      self.session_token ||= User.generate_session_token
    end
end
