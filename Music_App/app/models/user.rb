# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :email, :session_token, :password_digest, presence: true
    validates :email, :session_token, uniqueness: true 
    validates :password, length: {minimum:6, maximum:6}, allow_nil: true 

    before_validation :ensure_session_token 

    attr_reader :password

    #S.P.I.R.E

    def self.find_by_credentials(email, password)
        user = User.find_by(email: email)
        return  user && user.is_password?(password) ? user : nil 
    end 

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)    
    end 

    def is_password?(password)
        bcrypt_obj = BCrypt::Password.new(self.password_digest)
        bcrypt_obj.is_password?(password)
    end 

    def reset_session_token 
        self.session_token = generate_unique_session_token
        self.save!
        self.session_token
    end 

    
    private 
    def generate_unique_session_token 
        while true 
            token = SecureRandom::urlsafe_base64
            return token if !User.exists?(session_token: token)
        end 
    end 

    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end 

end
