module Librarix
  class Filter
    attr_reader :movies, :params

    def initialize(params)
      @params = params
      filter
    end

    private

    def filter
      @movies = Librarix::Redis::Movie.all
      by_title if @params.key?('title')

      @movies.sort_by!(&:release_date).reverse!
    end

    def by_title
      movies.select! { |movie| movie.title.downcase.include?(params['title']) }
    end
  end
end
