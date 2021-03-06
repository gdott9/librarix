require 'librarix/filter'
require 'librarix/menu'
require 'librarix/the_movie_db'
require 'librarix/helpers'

require 'sinatra/base'
require 'sinatra/content_for'
require 'sinatra/json'

require 'yaml'
require 'slim'
require 'themoviedb'

module Librarix
  class Application < Sinatra::Application
    def initialize(app = nil)
      super

      Librarix::Menu.menu.add 'Home', '/'
      Librarix::Menu.menu.add 'Add a movie', '/search'
    end

    helpers Librarix::TheMovieDB
    helpers Librarix::Menu::Helper
    helpers Librarix::Helpers

    get '/' do
      slim :index, locals: {filter: Librarix::Filter.new(params)}
    end

    get '/movie/:id' do |id|
      movie = Librarix::Redis::Movie.new(id).fetch

      if request.xhr?
        slim :'partials/movie', layout: false, locals: {movie: movie}
      else
        slim :movie, locals: {movie: movie}
      end
    end

    get '/search' do
      movies = if params['search'].nil?
        Tmdb::Movie.popular.map { |m| Tmdb::Movie.new(m) }
      elsif params['search'] == ''
        []
      else
        Tmdb::Movie.find(params['search'])
      end

      slim :search, locals: {movies: movies}
    end

    post '/add' do
      id = params[:id].to_i
      movie = Tmdb::Movie.detail(id)

      if movie['status_code'] == 34
      elsif Librarix::Redis::Movie.new(id).added?
      else
        Librarix::Redis::Movie.new(id).add
      end
      redirect to('/')
    end

    post '/update' do
      movie = Librarix::Redis::Movie.new(params[:id]).update

      if request.xhr?
        slim :'partials/movie', layout: false, locals: {movie: movie}
      else
        redirect to('/')
      end
    end

    post '/remove' do
      Librarix::Redis::Movie.new(params[:id]).remove

      if request.xhr?
        ""
      else
        redirect to('/')
      end
    end

    post '/view' do
      Librarix::Redis::Movie.new(params[:id]).view

      if request.xhr?
        ""
      else
        redirect to('/')
      end
    end
  end
end
