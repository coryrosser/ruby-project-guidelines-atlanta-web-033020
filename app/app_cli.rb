class AppCLI
    require_relative 'models/user.rb'
    require_relative 'models/payment.rb'
    attr_reader :prompt
    def initialize()
        @prompt = TTY::Prompt.new(active_color: :red)
    end

    def tell_balance(user)
        pastel = Pastel.new
        puts pastel.cyan("Your new available balance is $#{user.balance}.")
    end


    def main_user_interface(user)
        prompt = TTY::Prompt.new
        pastel = Pastel.new
        choice = nil
        puts pastel.yellow("Welcome to your account #{user.name}. What would you like to do today?")
        until choice == 7
        choice = prompt.select("Select from the options below:") do |menu|
            menu.choice 'Check account balance', 1
            menu.choice 'Make a deposit', 2
            menu.choice 'Make a withdrawal', 3
            menu.choice 'Transfer funds to another user', 4
            menu.choice 'Check transaction history', 5
            menu.choice 'See frequent expenses', 6
            menu.choice 'Logout', 7
            menu.choice pastel.red('Delete Account'), 8
            menu.choice 'Who Am I', 9
        end

            case choice 
            when 1
                puts pastel.cyan("Your available balance is $#{user.balance}.")

            when 2 
                get_amount =prompt.ask("Enter the deposit amount:").to_i
                user.deposit(get_amount)
                tell_balance(user)

            when 3
                get_amount =prompt.ask("Enter the withdrawal amount:").to_i
                if user.balance >= get_amount 
                    user.withdraw(get_amount)
                    tell_balance(user)
                else puts pastel.red("Declined. Insufficient funds.") 
                end

                
            when 4 
                get_amount =prompt.ask("Enter the transfer amount:").to_i
                recipient = prompt.ask('Who would you like to transfer funds to?')
                recipient_instance = User.find_by name: recipient
                if User.all.include?(recipient_instance)
                    user.make_payment(get_amount, recipient_instance.id)
                    puts pastel.green("Transfer Successful")

                else 
                    puts pastel.red("This user could not be found, please try again")
                    
                end
                
            when 5
                user.history
            when 6
                user.most_frequent
            when 7 
                login_screen
            when 8 
                choice = prompt.select("Are you sure you want to go through with this?", %w(Yes No))
                case choice
                when "Yes"
                    user.delete_account
                    login_screen
                when "No"
                    main_user_interface(user)
                else 
                    "Invalid Selection"
                end
            when 9 
               puts user.name
                puts "User no.#{user.id}" 
                puts "Balance of $#{user.balance}"

            end 

        end
    end

    def create_user
        prompt = TTY::Prompt.new
        name = prompt.ask("Enter your name", required: true)
        email = prompt.ask("Enter your email address", required: true) { |q| q.validate :email }
        User.create(name: name, email: email, balance: 0)
        pastel = Pastel.new 
        puts pastel.magenta("Welcome to SafeBank #{name}! \n Please login")
        login_screen
    end
    def choose_user
        prompt = TTY::Prompt.new
        user_list = User.all.map{|user| user.name}
        
        
       user_name = prompt.select("Select your name! Dont peek at other peoples accounts!", user_list - ["Admin"])
       active_user_instance = User.find_by name: user_name
       #binding.pry
       main_user_interface(active_user_instance)

    end
    
    def login_screen
        prompt = TTY::Prompt.new
        choice = prompt.select('Are you a New or Existing User?', %w(New_User Existing_User))

        case choice
        when "New_User"
            create_user
        when "Existing_User"
            choose_user
        else 
            "Invalid Selection"
        end

        puts pastel.cyan("#{User.all.count} users currently signed up! Help us grow!")
        
    end
    def run 

        pastel = Pastel.new
        font = TTY::Font.new(:starwars)
        puts pastel.yellow(font.write("SafeBank"))
        puts pastel.cyan("No better place to store all your sensitive information!")
        login_screen
    end
end