class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @ratings = params[:ratings]
    @all_ratings = Movie.ratings
    @sort = params[:sort]
    if (@ratings == nil && @sort == nil) && (session[:ratings] != nil || session[:sort] != nil)
      if session[:ratings] != nil && @ratings == nil
        @ratings = session[:ratings]
      end
      if session[:sort] != nil && @sort == nil
        @sort = session[:sort]      
      end
      flash.keep
      redirect_to :ratings => @ratings, :sort => @sort
    end   
    if @ratings != nil
      session[:ratings] = @ratings
      r = @ratings.keys
      w = "rating = 'S'"
      r.each do |x|
        w << " or rating = '#{x}'"
      end      
      if @sort == nil
        @movies = Movie.where(w)     
      else
        session[:sort] = @sort
        @movies = Movie.order(@sort).where(w)     
      end
    else
      if @sort == nil
        @movies = Movie.all    
      else
        session[:sort] = @sort
        @movies = Movie.order(@sort).all    
      end
    end
      
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
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
    redirect_to movies_path
  end

end
