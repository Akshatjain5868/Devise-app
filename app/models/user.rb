class User < ApplicationRecord
    has_one_attached :profile_image
    attr_accessor :password

    validates :email, uniqueness: true, length: {in: 5..50}
    validates :password, presence: true,confirmation: true, length: {in: 4..20} , on: :create

    before_save :encrypt_password

    def self.authenticate(email,password)
        user = find_by_email(email)
        return user if user && user.authenticated_password(password)
    end

    def authenticated_password(password)
        return  self.encrypted_password == encrypt(password)
    end
    protected
    def encrypt_password
        if password.blank?
            return true
        end
        self.encrypted_password = encrypt(password)
        
    end

    def encrypt(string)
        Digest::SHA1.hexdigest(string)
    end

end
