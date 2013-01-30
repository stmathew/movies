class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
     
    @all_ratings = Movie.all_ratings  
    
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
     
    if params[:ratings].nil? || params[:ratings].empty?
        #params[:ratings] = session[:ratings] unless session[:ratings].nil?
        flash.keep
        redirect_to movies_path({ratings: session[:ratings]})
    end
    
    @ratings = params[:ratings].keys unless params[:ratings].nil?
    @ratings ||= @all_ratings

    @sort = params[:sort]
        
    if @sort.nil?
      if @ratings.empty?
        @movies = Movie.find(:all, :conditions => [ "rating IN (?)", @all_ratings] )
      else
        @movies = Movie.find(:all, :conditions => [ "rating IN (?)", @ratings] )
      end
    else
      if @ratings.empty?
        @movies = Movie.find(:all, :conditions => [ "rating IN (?)", @all_ratings], :order => @sort)
      else
        @movies = Movie.find(:all, :conditions => [ "rating IN (?)", @ratings], :order => @sort)
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
