class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings # ['G','PG','PG-13','R']
    @sort = params['sort']
    session[:sort] = @sort
    session[:ratings] = save_ratings(@all_ratings)
    @checked_ratings = params['ratings'] != nil ? params['ratings'].keys : @all_ratings 
    @movies = Movie.where(rating: @checked_ratings).order(session[:sort])
    session[:ratings] = save_ratings(@checked_ratings)
    # session[:return_to] = request.fullpath
  end

  def save_ratings(arr)
    # "ratings"=>{"PG-13"=>"on", "R"=>"1"}
    saved_ratings = Hash.new()
    arr.each do |rating|
      saved_ratings[rating] = "1"
    end
    saved_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings]) # (session[:return_to]) # movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings]) # (session[:return_to]) # movies_path
  end

end
