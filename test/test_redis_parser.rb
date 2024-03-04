require 'minitest/autorun'
require_relative '../app/redis_parser'

class TestRedisParser < Minitest::Test
  def test_ping
    assert_equal({ command: :ping, args: [] }, RedisParser.parse("*1\r\n$4\r\nping\r\n"))
  end

  def test_echo
    assert_equal(
      { command: :echo, args: ['bingoasdfasd'] },
      RedisParser.parse("*2\r\n$4\r\necho\r\n$12\r\nbingoasdfasd\r\n")
    )
  end

  def test_set
    assert_equal(
      { command: :set, args: %w[z 123124] },
      RedisParser.parse("*3\r\n$3\r\nset\r\n$1\r\nz\r\n$6\r\n123124\r\n")
    )
  end

  def test_get
    assert_equal(
      { command: :get, args: ['z'] },
      RedisParser.parse("*2\r\n$3\r\nget\r\n$1\r\nz\r\n")
    )
  end
end
