require 'redis'

module Librarix
  class Redis
    TTL = 10800

    attr_reader :connection, :namespace

    def initialize(connection, namespace:)
      @connection = connection
      @namespace = namespace
    end

    def exist?(key)
      exists key
    end

    def keys(pattern)
      @connection.keys("#{prefix}#{pattern}").map { |key| key.sub(prefix, '') }
    end

    def fetch(key, options = {})
      if options[:force] || (!exist?(key) && block_given?)
        value = yield
        set key, value
        expire key, TTL if options.key?(:ttl) && options[:ttl]

        value
      else
        get key
      end
    end

    def respond_to?(name, include_all = false)
      super || @connection.respond_to?(name, include_all)
    end

    def method_missing(name, *args, &block)
      return super unless @connection.respond_to?(name)
      @connection.send(name, "#{prefix}#{args.shift}", *args)
    end

    private

    def prefix
      "#{namespace}:"
    end
  end
end
