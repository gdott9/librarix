require 'librarix/the_movie_db'

require 'sinatra/base'
require 'sinatra/content_for'
require 'sinatra/json'

require 'yaml'
require 'slim'
require 'themoviedb'

module Librarix
  class Application < Sinatra::Application
    helpers Librarix::TheMovieDB

    get '/' do
      slim :index, locals: {movies: Librarix::Redis::Movie.all.sort_by(&:release_date).reverse}
    end

    get '/search' do
      movies = if params['search'].nil?
        Tmdb::Movie.popular.map { |m| Tmdb::Movie.new(m) }
      elsif params['search'] == ''
        []
      else
        Tmdb::Movie.find(params['search'])
      end

      if request.xhr?
        slim :list, layout: false, locals: {movies: movies}
      else
        slim :search, locals: {movies: movies}
      end
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

    post '/remove' do
      Librarix::Redis::Movie.new(params[:id]).remove

      if request.xhr?
        ""
      else
        redirect to('/')
      end
    end
  end
end
