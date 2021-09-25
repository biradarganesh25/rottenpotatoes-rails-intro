class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_ratings

    @movies = Movie.all

    sortable_columns = ['title','release_date']
    if params.key?('sort') && (sortable_columns.include?(params['sort']))
        session['sort']=params['sort']
    end

    if session['sort'] != nil && params['sort']==nil
      flash.keep
      redirect_to movies_path(request.parameters.merge(sort:session['sort'])) and return
    end

    if params.key? 'ratings' 
      session['ratings']=params['ratings']
    elsif session['ratings']==nil
      session['ratings']={}
      @all_ratings.each do |rating|
        session['ratings'][rating]=1
      end
    end

    if session['ratings'] != nil && (params['ratings'] == nil)
      flash.keep
      redirect_to movies_path(request.parameters.merge(ratings:session['ratings']))
    end
    
    if session['sort'] != nil
      @movies = @movies.all.order(session['sort'])
    end
    if session['ratings'] != nil
      @movies = @movies.filter_movies_by_ratings(session['ratings'])
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
