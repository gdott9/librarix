module Librarix
  module Helpers
    def template
      if %w{default compact poster}.include?(params['template'])
        params['template']
      else
        'default'
      end
    end
  end
end
