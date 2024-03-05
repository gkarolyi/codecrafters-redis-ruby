module RedisParser
  def self.decode(input)
    return if input.empty?

    resp_array = input.split("\r\n")
    chunks = resp_array[1..].each_slice(2).to_a
    command = chunks.first[1].to_sym
    args = chunks[1..].map { |chunk| chunk[1] }

    {
      command:,
      args:
    }
  end

  def self.encode(input)
    return if input.empty?

    str_array = input.split(' ')
    commands = str_array.map { |str| ["$#{str.length}", str.downcase] }.flatten

    ["*#{str_array.length}", commands]
      .join("\r\n")
      .concat("\r\n")
  end

  def self.read_echo(client)
    length = read_length(client)
    read_bytes(client, length)
  end

  def self.read_set(client)
    klength = read_length(client)
    key = read_bytes(client, klength)
    vlength = read_length(client)
    value = read_bytes(client, vlength)

    [key, value]
  end

  def self.read_get(client)
    klength = read_length(client)
    read_bytes(client, klength)
  end

  private

  def self.read_length(client)
    client.gets.gsub(/\D/, '').to_i
  end

  def self.read_bytes(client, length, separator = 2)
    client.read(length + separator).strip
  end
end
