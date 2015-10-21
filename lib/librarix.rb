require 'librarix/version'
require 'librarix/redis'
require 'librarix/redis/movie'

require 'librarix/application'

module Librarix
  def self.redis
    @redis ||= Librarix::Redis.new(::Redis.new)
  end

  def self.redis=(connection, namespace: 'librarix')
    @redis = Librarix::Redis.new(connection, namespace: namespace)
  end
end
