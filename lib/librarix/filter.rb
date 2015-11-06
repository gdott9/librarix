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
      by_view_state if @params.key?('view_state')

      @movies.sort_by!(&:release_date).reverse!
    end

    def by_title
      movies.select! { |movie| movie.title.downcase.include?(params['title']) }
    end

    def by_view_state
      if params['view_state'] == 'viewed'
        movies.keep_if(&:viewed?)
      elsif params['view_state'] == 'not_viewed'
        movies.delete_if(&:viewed?)
      end
    end
  end
end
