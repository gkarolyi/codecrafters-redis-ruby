module RedisParser
  def self.parse(input)
    return unless input

    resp_array = input.split("\r\n")
    chunks = resp_array[1..].each_slice(2).to_a
    command = chunks.first[1]
    args = chunks[1..].map { |chunk| chunk[1] }

    {
      command: command.to_sym,
      args:
    }
  end
end
