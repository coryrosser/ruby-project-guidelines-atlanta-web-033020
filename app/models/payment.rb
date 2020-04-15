class Payment < ActiveRecord::Base
    belongs_to :user 
    belongs_to :recipient_user, class_name: "User"
end