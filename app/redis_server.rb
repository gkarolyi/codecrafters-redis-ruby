require 'socket'
require_relative 'redis_parser'

class RedisServer
  attr_reader :server
  attr_accessor :store

  def initialize(port)
    @port = port
    @server = TCPServer.new(@port)
    @store = {}
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
      case get_line(client)
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
    key, value = RedisParser.read_set(client)
    store[key] = value
    respond(client, 'OK')
  end

  def handle_get(client)
    key = RedisParser.read_get(client)
    value = store[key]
    return respond(client, nil, null: true) unless value

    respond(client, value)
  end

  def get_line(client)
    client.gets&.strip
  end

  def respond(client, response, null: false)
    response = null ? "$-1\r\n" : "+#{response}\r\n"
    client.write(response)
  end
end
