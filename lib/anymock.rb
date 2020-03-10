require "anymock/version"
require "anymock/cli"
require "webrick"
require "json"
require "logger"

module Anymock
  class Server
    attr_accessor :document_root, :address, :port

    def initialize(opts = {})
      @document_root = opts[:document_root]
      @address = opts[:address]
      @port = opts[:port]
      @response = opts[:response]
      @file = opts[:file]
      @log = opts[:log]
      @mirror = opts[:mirror]
      @json = opts[:json]
    end

    def start
      server.mount_proc '/' do |req, res|
        output_params = {
          path: req.path,
          method: req.request_method,
          query: req.query
        }
        res.status = status_code(req.request_method)
        if @file
          File.open(@file) do |f|
            res.body = f.read
          end
        elsif @response
          res.body = @response
        elsif @mirror
          res.body = req_string
        else
          res.status = 204
        end
        output output_params.merge({ response: res.body })
      end
      server.start
    end

    def output(params)
      if @json
        logger.info params.to_json
      else
        logger.info '----'
        %i(path method query response).each do |n|
          logger.info "#{n}:"
          logger.info params[n]
        end
        logger.info '----'
      end
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

    def logger
      @logger ||= Logger.new(log)
    end

    def log
      @log || STDOUT
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
