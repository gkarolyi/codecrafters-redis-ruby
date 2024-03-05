require 'socket'

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
    _length = get_line(client)
    message = get_line(client)
    respond(client, message)
  end

  def handle_set(client)
    _klength = get_line(client)
    key = get_line(client)
    _vlength = get_line(client)
    value = get_line(client)
    store[key] = value
    respond(client, 'OK')
  end

  def handle_get(client)
    _ = get_line(client)
    key = get_line(client)
    value = store[key]
    value ? respond(client, value) : client.write("$-1\r\n")
  end

  def get_line(client)
    client.gets&.strip
  end

  def respond(client, response)
    client.write("+#{response}\r\n")
  end
end
