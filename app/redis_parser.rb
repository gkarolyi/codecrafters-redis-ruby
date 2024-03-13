module RedisParser
  def self.read_echo(client)
    length = read_length(client)
    read_bytes(client, length)
  end

  def self.read_set(client)
    klength = read_length(client)
    key = read_bytes(client, klength)
    vlength = read_length(client)
    value = read_bytes(client, vlength)
    expiry = read_expiry(client)

    [key, value, expiry]
  end

  def self.read_get(client)
    klength = read_length(client)
    read_bytes(client, klength)
  end

  def self.read_length(client)
    client.gets.gsub(/\D/, '').to_i
  end

  def self.read_bytes(client, length, separator = 2)
    client.read(length + separator).strip
  end

  def self.read_expiry(client)
    px = client.read_nonblock(8)
    return 0 unless px.include?('px')

    xlength = client.read_nonblock(4).gsub(/\D/, '').to_i
    client.read_nonblock(xlength).to_i
  rescue IO::EAGAINWaitReadable
    0
  end

  private_class_method :read_length, :read_bytes, :read_expiry
end
