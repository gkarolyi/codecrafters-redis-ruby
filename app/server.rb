require "socket"

class YourRedisServer
  attr_reader :server

  def initialize(port)
    @port = port
    @server = TCPServer.new(@port)
  end

  def start
    client = server.accept
    loop do
      command = client.gets.upcase
      case command
      when /PING/i
        client.puts("+PONG\r\n")
      end
    end
  end
end

YourRedisServer.new(6379).start
