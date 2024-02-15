# frozen_string_literal: true

# This class is responsible for responding to an individual client connection.
class ClientHandler
  attr_reader :client

  def initialize(client)
    @client = client
  end

  def handle_client
    loop do
      case input_line
      when /PING/i
        respond('PONG')
      when /ECHO/i
        _delimiter = input_line
        message = input_line
        respond(message)
      end
    end
  end

  private

  def input_line
    client.gets&.strip
  end

  def respond(response)
    client.puts("+#{response}\r\n")
  end
end
