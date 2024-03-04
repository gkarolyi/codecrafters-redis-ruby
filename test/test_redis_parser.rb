require 'minitest/autorun'
require_relative '../app/redis_parser'

class TestRedisParser < Minitest::Test
  def test_decode_ping
    assert_equal({ command: :ping, args: [] }, RedisParser.decode("*1\r\n$4\r\nping\r\n"))
  end

  def test_decode_echo
    assert_equal(
      { command: :echo, args: ['bingoasdfasd'] },
      RedisParser.decode("*2\r\n$4\r\necho\r\n$12\r\nbingoasdfasd\r\n")
    )
  end

  def test_decode_set
    assert_equal(
      { command: :set, args: %w[z 123124] },
      RedisParser.decode("*3\r\n$3\r\nset\r\n$1\r\nz\r\n$6\r\n123124\r\n")
    )
  end

  def test_decode_get
    assert_equal(
      { command: :get, args: ['z'] },
      RedisParser.decode("*2\r\n$3\r\nget\r\n$1\r\nz\r\n")
    )
  end

  def test_decode_blank
    assert_nil RedisParser.decode('')
  end

  def test_encode_ping
    assert_equal "*1\r\n$4\r\nping\r\n", RedisParser.encode('PING')
  end

  def test_encode_echo
    assert_equal "*2\r\n$4\r\necho\r\n$12\r\nbingoasdfasd\r\n", RedisParser.encode('ECHO bingoasdfasd')
  end

  def test_encode_set
    assert_equal "*3\r\n$3\r\nset\r\n$1\r\nz\r\n$6\r\n123124\r\n", RedisParser.encode('SET z 123124')
  end

  def test_encode_get
    assert_equal "*2\r\n$3\r\nget\r\n$1\r\nz\r\n", RedisParser.encode('GET z')
  end
end
