require 'thor'

module Anymock
  class CLI < Thor
    default_command :start_server

    option :d, type: :string, default: 'public/'
    option :a, type: :string, default: 'localhost'
    option :p, type: :string, default: '8080'
    option :r, type: :string, default: nil
    option :m, type: :boolean, default: false

    desc "start", "start mock server"

    def start_server
      server.start
    end

    private

    def server
      @anymock ||= Anymock::Server.new option_strings
    end

    def option_strings
      {
        document_root: options[:d],
        address: options[:a],
        port: options[:p],
        response: options[:r],
        mirror: options[:m]
      }
    end
  end
end
