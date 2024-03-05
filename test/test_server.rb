require 'minitest/autorun'
require_relative '../app/redis_server'

class TestServer < Minitest::Test
  attr_reader :socket

  PORT = 6381
  SERVER = Thread.new { RedisServer.new(PORT).start }

  def setup
    @socket = TCPSocket.new('localhost', PORT)
  end

  def test_ping
    socket.puts "*1\r\n$4\r\nping\r\n"
    response = socket.gets
    assert_equal "+PONG\r\n", response
  end

  def test_echo
    socket.puts "*2\r\n$4\r\necho\r\n$12\r\nbingoasdfasd\r\n"
    response = socket.gets
    assert_equal "+bingoasdfasd\r\n", response
  end

  def test_set
    socket.puts "*3\r\n$3\r\nset\r\n$1\r\nz\r\n$6\r\n123124\r\n"
    response = socket.gets
    assert_equal "+OK\r\n", response
  end

  def test_set_then_get_existing_key
    socket.puts "*3\r\n$3\r\nset\r\n$1\r\nz\r\n$6\r\n123124\r\n"
    response = socket.gets
    assert_equal "+OK\r\n", response
    socket.puts "*2\r\n$3\r\nget\r\n$1\r\nz\r\n"
    response = socket.gets
    assert_equal "+123124\r\n", response
  end

  def test_get_non_existing_key
    socket.puts "*2\r\n$3\r\nget\r\n$1\r\nnonexistent\r\n"
    response = socket.gets
    assert_equal "$-1\r\n", response
  end
end
