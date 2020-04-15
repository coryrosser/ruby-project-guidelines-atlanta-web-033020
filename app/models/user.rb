class User < ActiveRecord::Base 
    has_many :payments
    has_many :recipient_users, through: :payments
    has_many :recipients, foreign_key: :recipient_user_id,
        class_name: 'Payment'
    has_many :recipient_users, through: :recipients, source: :user

    def make_payment(amount, recipient_user_id)
        recipient = User.find(recipient_user_id)

        if self.balance >= amount
            Payment.create(amount: amount, user_id: self.id, recipient_user_id: recipient.id)
            recipient.balance += amount
            recipient.save

            self.balance -= amount
            self.save
            "You have successfully transferred $#{amount} to #{recipient.name}"
        else
            "Declined: Insufficient Funds."
        end
    end

    def deposit(amount)
        self.balance += amount
        self.save
        "You have deposited $#{amount}. Your new balance is $#{balance}"
    end
    def withdraw(amount)
        if self.balance >= amount
        self.balance -= amount
        self.save
        else
            "Declined: Insufficient Funds."
        end
    end
    def history

        pastel =Pastel.new
        pays = Payment.all.where(user_id: self.id)
        pays.map{|entry| puts pastel.green("You sent $#{entry.amount} to #{User.find(entry.recipient_user_id).name} on #{entry.created_at}.")}

    end
    def most_frequent
        history.group_by('recipient_user_id').order('COUNT(*) DESC') #Need help with this. "Wrong number of args error?"
    end


end