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
end
