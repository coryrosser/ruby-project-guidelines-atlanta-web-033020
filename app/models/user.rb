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
        received = Payment.all.where(recipient_user_id: self.id)
        pays.map{|entry| puts pastel.red("You sent $#{entry.amount} to #{if User.find_by(id: entry.recipient_user_id) == nil 
        "a user that has deleted their account" else User.find_by(id: entry.recipient_user_id).name end} on #{entry.created_at}.")}
        received.map{|entry| puts pastel.green("You received $#{entry.amount} from #{if User.find_by(id: entry.recipient_user_id) == nil 
        "a user that has deleted their account" else User.find_by(id: entry.recipient_user_id).name end} on #{entry.created_at}.")}
        

    end
    def most_frequent
        return_id = Payment.all.where(user_id: self.id).group('recipient_user_id').order('COUNT(*) DESC').select('recipient_user_id').limit(1)

        binding.pry

    end


end