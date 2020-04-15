class AppCLI
    # attr_reader :prompt
    def initialize()
        # @prompt = TTY::Prompt.new(active_color: :magenta)
    end

    def create_user
        prompt = TTY::Prompt.new
        name = prompt.ask("Enter your name")
        email = prompt.ask("Enter your email address")
        User.create(name: name, email: email, balance: 0)
    end
    
    def login_screen
        prompt = TTY::Prompt.new
        choice = prompt.select('New or Existing User?', %w(New Existing))

        case choice
        when 1 
            create_user
        when 2 
            choose_user
        else 
            "Invalid Selection"
        end
        
    end
    def run 
        pastel = Pastel.new
        font = TTY::Font.new(:starwars)
        puts pastel.cyan(font.write("Welcome to SafeBank!"))

        

    end
end