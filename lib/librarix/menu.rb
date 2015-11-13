module Librarix
  class Menu
    module Helper
      def menu
        Librarix::Menu.menu.render request.path_info
      end
    end

    def self.menu
      @menu ||= new
    end

    attr_accessor :menu

    def initialize
      self.menu = []
    end

    def add(name, url)
      self.menu << Element.new(name, url)
    end

    def render(path = nil)
      around menu.map { |elem| elem.render path }.join
    end

    private

    def around(content)
      "<ul id=\"menu\">#{content}</ul>"
    end

    class Element
      attr_accessor :name, :url

      def initialize(name, url)
        self.name = name
        self.url = url
      end

      def render(path = nil)
        around "<a href=\"#{url}\">#{name}</a>", path: path
      end

      def current?(path)
        path == url
      end

      private

      def around(element, path: nil)
        "<li#{current?(path) ? ' class="active"' : ''}>#{element}</li>"
      end
    end
  end
end
