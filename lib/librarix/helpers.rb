module Librarix
  module Helpers
    def template
      if %w{default compact poster}.include?(params['template'])
        params['template']
      else
        'default'
      end
    end

    def maybe_search?(movies)
      movies.empty? && params.key?('title')
    end
  end
end
