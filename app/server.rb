require "socket"

class YourRedisServer
  def initialize(port)
    @port = port
  end

  def start
    server = TCPServer.new(@port)
    loop do
      client = server.accept
      command = client.gets
      if command
        client.puts "+PONG\r\n"
      end
    end
  end
end

YourRedisServer.new(6379).start
