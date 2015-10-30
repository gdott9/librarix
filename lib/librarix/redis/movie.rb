module Librarix
  class Redis
    class Movie
      attr_reader :id

      def self.all
        Array(Librarix.redis.smembers('movies_id')).map { |id| new(id).fetch }
      end

      def initialize(id)
        @id = id.to_i
      end

      def add
        Librarix.redis.sadd('movies_id', id)
        fetch
      end

      def added?
        Librarix.redis.sismember('movies_id', id)
      end

      def fetch(force = false)
        data = JSON.parse(Librarix.redis.fetch("movie:#{id}", force: force) do
          Tmdb::Movie.detail(id).to_json
        end)

        Tmdb::Movie.new(data)
      end

      def update
        fetch(true)
      end

      def remove
        Librarix.redis.del("movie:#{id}")
        Librarix.redis.srem('movies_id', id)
      end

      def view
        Librarix.redis.sadd('viewed_movies_id', id)
      end

      def viewed?
        Librarix.redis.sismember('viewed_movies_id', id)
      end
    end
  end
end
