require_relative '../config/environment'
require_relative '../app/app_cli'
require 'tty'
require 'tty-prompt'
AppCLI.new.run