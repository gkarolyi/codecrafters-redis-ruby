# frozen_string_literal: true

require_relative 'redis_server'

RedisServer.new(6379).start
