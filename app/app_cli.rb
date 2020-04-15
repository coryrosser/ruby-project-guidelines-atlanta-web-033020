class AppCLI
    require_relative 'models/user.rb'
    # attr_reader :prompt
    def initialize()
        # @prompt = TTY::Prompt.new(active_color: :magenta)
    end

    def main_user_interface(user)
        pastel = Pastel.new
        puts pastel.yellow("Welcome to your account #{user.name}. What would you like to do today?")

    end

    def create_user
        prompt = TTY::Prompt.new
        name = prompt.ask("Enter your name")
        email = prompt.ask("Enter your email address")
        User.create(name: name, email: email, balance: 0)
        pastel = Pastel.new 
        puts pastel.magenta("Welcome to SafeBank #{name}! \n Please press 2. to login")
        login_screen
    end
    def choose_user
        prompt = TTY::Prompt.new
        user_list = User.all.map{|user| user.name}
        
        
       user_name = prompt.select("Select your name! Dont peek at other peoples accounts!", user_list)
       active_user_instance = User.find_by name: user_name
       binding.pry
       main_user_interface(active_user_instance)

    end
    
    def login_screen
        prompt = TTY::Prompt.new
        choice = prompt.select('Press 1. for New User or 2. for Existing User?', %w(1 2))

        case choice
        when "1"
            create_user
        when "2"
            choose_user
        else 
            "Invalid Selection"
        end

        puts pastel.cyan("#{User.all.count} users currently signed up! Help us grow!")
        
    end
    def run 
        pastel = Pastel.new
        font = TTY::Font.new(:starwars)
        puts pastel.cyan(font.write("SafeBank"))
        puts pastel.cyan("No better place to store all your sensitive information!")
        login_screen
    end
end