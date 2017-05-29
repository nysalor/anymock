require "anymock/version"
require "anymock/cli"
require "webrick"
require "json"

module Anymock
  class Server
    attr_accessor :document_root, :address, :port

    def initialize(opts = {})
      @document_root = opts[:document_root]
      @address = opts[:address]
      @port = opts[:port]
      @mirror = opts[:mirror]
    end

    def start
      server.mount_proc '/' do |req, res|
        body = { req.request_method => req.query }.to_json
        res.body = body
        output body if @mirror
      end
      server.start
    end

    def output(body)
      puts "response:"
      puts "----"
      puts body
      puts "----"
    end

    private

    def server
      @server ||= WEBrick::HTTPServer.new({
          DocumentRoot: document_root,
          BindAddress: address,
          Port: port
        })
    end
  end
end
