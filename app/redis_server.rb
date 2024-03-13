require 'socket'
require_relative 'redis_parser'

class RedisServer
  attr_reader :server
  attr_accessor :store, :expiries

  def initialize(port)
    @port = port
    @server = TCPServer.new(@port)
    @store = {}
    @expiries = {}
  end

  def start
    loop do
      client = server.accept
      Thread.new { handle_client(client) }
    end
  end

  private

  # rubocop:disable Metrics/MethodLength
  def handle_client(client)
    loop do
      case client.gets
      when /PING/i
        respond(client, 'PONG')
      when /ECHO/i
        handle_echo(client)
      when /SET/i
        handle_set(client)
      when /GET/i
        handle_get(client)
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  def handle_echo(client)
    message = RedisParser.read_echo(client)
    respond(client, message)
  end

  def handle_set(client)
    key, value, expiry = RedisParser.read_set(client)
    expiries[key] = Time.now.to_f + (1.0 / expiry) if expiry
    store[key] = value
    respond(client, 'OK')
  end

  def handle_get(client)
    key = RedisParser.read_get(client)
    return respond(client, nil) if expiries[key] && expiries[key] < Time.now.to_f

    respond(client, store[key])
  end

  def respond(client, response)
    if response.nil?
      client.write("$-1\r\n")
    else
      client.write("+#{response}\r\n")
    end
  end
end
