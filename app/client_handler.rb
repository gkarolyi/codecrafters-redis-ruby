# frozen_string_literal: true

# This class is responsible for responding to an individual client connection.
class ClientHandler
  attr_reader :client
  attr_accessor :store

  def initialize(client)
    @client = client
    @store = {}
  end

  # rubocop:disable Metrics/MethodLength
  def handle_client
    loop do
      case input_line
      when /PING/i
        respond('PONG')
      when /ECHO/i
        _delimiter = input_line
        message = input_line
        respond(message)
      when /SET/i
        _ = input_line
        key = input_line
        _ = input_line
        value = input_line
        store[key] = value
        respond('OK')
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def input_line
    client.gets&.strip
  end

  def respond(response)
    client.puts("+#{response}\r\n")
  end
end
