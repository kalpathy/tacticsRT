class User < ActiveRecord::Base
  has_many :contouring_sessions
  
  acts_as_authentic do |c|
      c.login_field = :email
    end
    
    def deliver_password_reset_instructions!  
      reset_perishable_token!  
      Notifier.deliver_password_reset_instructions(self)  
    end
end
