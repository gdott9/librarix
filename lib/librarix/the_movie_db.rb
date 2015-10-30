require 'themoviedb'

module Librarix
  module TheMovieDB
    def poster_url(path, size = 'w92')
      base_url = Librarix.redis.fetch('base_url', ttl: true) do
        Tmdb::Configuration.new.base_url
      end

      "#{base_url}#{size}#{path}"
    end

    def movie(id)
      Librarix::Redis::Movie.new(id).fetch
    end

    module Movie
      def release_date
        @_release_date ||= Date.parse(super) unless super.nil?
      end

      def release_year
        release_date.year unless release_date.nil?
      end

      def added?
        Librarix::Redis::Movie.new(id).added?
      end

      def viewed?
        Librarix::Redis::Movie.new(id).viewed?
      end
    end
  end
end

Tmdb::Movie.prepend Librarix::TheMovieDB::Movie
