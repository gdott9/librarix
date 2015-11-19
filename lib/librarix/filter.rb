module Librarix
  class Filter
    def self.filter_by_genre(movies, genres)
      return movies if genres.empty?
      movies.reject do |movie|
        (movie.genres.map { |genre| genre['name'] } & genres).empty?
      end
    end

    def self.filter_by_title(movies, title)
      return movies unless title
      movies.select { |movie| movie.title.downcase.include?(title) }
    end

    def self.filter_by_view_state(movies, view_state)
      if view_state == 'viewed'
        movies.select(&:viewed?)
      elsif view_state == 'not_viewed'
        movies.reject(&:viewed?)
      else
        movies
      end
    end

    def self.sort(movies, sort)
      if sort == 'date'
        movies.sort_by(&:release_date).reverse
      else
        movies.sort_by(&:title)
      end
    end

    def self.group(movies, group, sort)
      return {all: movies} unless group

      if sort == 'date'
        movies.group_by { |movie| movie.release_date.year }
      else
        movies.group_by { |movie| movie.title[0].upcase }
      end
    end

    attr_reader :movies, :params

    def initialize(params)
      @params = params
    end

    def movies
      @movies ||= begin
        movies = Librarix::Redis::Movie.all

        movies = self.class.filter_by_genre(movies, genres)
        movies = self.class.filter_by_title(movies, params['title'])
        movies = self.class.filter_by_view_state(movies, params['view_state'])

        movies = self.class.sort(movies, sort)
        movies = self.class.group(movies, group, sort)
      end
    end

    def group
      @group ||= params.key?('group') && params['group']
    end

    def genres
      @genres ||= params.key?('genres') ? params['genres'].keys : []
    end

    def view_state
      @view_state ||= if %w{all viewed not_viewed}.include?(params['view_state'])
        params['view_state']
      else
        'all'
      end
    end

    def sort
      @sort ||= if %w{alphabetical date}.include?(params['sort'])
        params['sort']
      else
        'date'
      end
    end

    def maybe_search?
      movies.all? { |k,v| v.empty? } && params.key?('title')
    end
  end
end
