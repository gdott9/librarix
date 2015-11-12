module Librarix
  module Helpers
    def compact?
      params.key?('compact')
    end
  end
end
