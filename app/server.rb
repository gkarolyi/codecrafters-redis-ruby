# frozen_string_literal: true

require 'socket'
require_relative 'client_handler'

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
        ClientHandler.new(client).handle_client
      end
    end
  end
end

YourRedisServer.new(6379).start
