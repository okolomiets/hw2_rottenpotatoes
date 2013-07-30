class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.ratings # ['G','PG','PG-13','R']
    
    if !['title','release_date', nil].include? params['sort']
      # flash[:message] = "Sorting params are wrong. Redirecting to saved session..."
      session[:sort] = session[:sort] != nil ? session[:sort] : nil
      redirect_to movies_path(:sort => session[:sort], :ratings => params['ratings']) 
    elsif params['ratings'] == nil
      # flash[:message] = "Ratings params are missed. Redirecting to saved session..."
      session[:ratings] = session[:ratings] != nil ? session[:ratings] : @all_ratings
      redirect_to movies_path(:sort => params['sort'], :ratings => save_ratings(session[:ratings])) 
    else
      @sort = params['sort'] == nil ? session[:sort] : params['sort']
      # @checked_ratings = params['ratings'] != nil ? params['ratings'].keys : (session[:ratings] != nil ? session[:ratings] : @all_ratings) # session[:ratings].keys 
      @checked_ratings = params['ratings'].keys 
      @movies = Movie.where(rating: @checked_ratings).order(@sort)
      session[:sort] = @sort
      session[:ratings] = @checked_ratings
      @ratings_hash = save_ratings(session[:ratings])
      # session[:return_to] = request.fullpath
    end
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
    redirect_to movies_path(:sort => session[:sort], :ratings => @ratings_hash) # (session[:return_to]) # movies_path
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
    redirect_to movies_path(:sort => session[:sort], :ratings => @ratings_hash) # (session[:return_to]) # movies_path
  end

end
