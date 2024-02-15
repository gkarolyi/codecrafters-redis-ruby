# frozen_string_literal: true

require 'socket'
# Toy Redis server built with Ruby's TCPServer.
class YourRedisServer
  attr_reader :server

  def initialize(port)
    @port = port
    @server = TCPServer.new(@port)
  end

  def start
    loop do
      Thread.new(server.accept) do |client|
        handle_client(client)
      end
    end
  end

  def handle_client(client)
    loop do
      command = client.gets&.strip
      case command
      when /PING/i
        client.puts("+PONG\r\n")
      when /ECHO/i
        handle_echo(client)
      end
    end
  end

  def handle_echo(client)
    delimiter = client.gets&.strip
    message = client.gets&.strip
    client.puts("+#{message}\r\n")
  end
end

YourRedisServer.new(6379).start
