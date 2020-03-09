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
      @response = opts[:response]
      @mirror = opts[:mirror]
    end

    def start
      server.mount_proc '/' do |req, res|
        req_string = { req.request_method => req.query }.to_json
        res.status = status_code(req.request_method)
        if @response
          res.body = @response
        elsif @mirror
          res.body = req_string
        else
          res.status = 204
        end
        output req_string, res.body
      end
      server.start
    end

    def output(req, body)
      puts "request:"
      puts "----"
      puts body
      puts "----"
      puts "response:"
      puts "----"
      puts body
      puts "----"
    end

    private

    def status_code(request_method)
      case request_method
      when 'GET'
        200
      when 'POST'
        201
      when 'PUT'
        200
      end
    end

    def server
      @server ||= WEBrick::HTTPServer.new({
          DocumentRoot: document_root,
          BindAddress: address,
          Port: port
        })
    end
  end
end
