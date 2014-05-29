class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
#     debugger

     # inject parameters if session is not empty
     injected_params = inject_if_missing_params(params, session)
    
     if !injected_params.empty?
        # this may iterate twice through inject_if_missing if both missing
        flash.keep
        redirect_to movies_path(injected_params)
     end

     # default is nil to imply no hilite
     @title_class = ""
     @date_class = ""

     # need ratings for Movie filter function
     @all_ratings = Movie.all_ratings
     @selected_ratings = params[:ratings].nil? ? @all_ratings : params[:ratings].keys

     # processes @movies by order or by ratings, sets @title_class/@date_class
     if params.has_key? :sort
        if params[:sort] == "title_header"
#@movies = Movie.order("title ASC") # look up movie by unique ID
         @movies = Movie.sort_and_filter("title ASC", @selected_ratings) # look up movie by unique ID
         @title_class = "hilite"
        elsif params[:sort] == "release_date_header"
          @movies = Movie.sort_and_filter("release_date ASC", @selected_ratings) # look up movie by unique ID
          @date_class = "hilite"
        else
          @movies = Movie.all
        end
     else

        @movies = Movie.all_filter_on_ratings @selected_ratings
     end

     # store parameters for future
     if !params[:sort].nil?
        session[:sort] = params[:sort]
     end

     if !params[:ratings].nil?
        session[:ratings] = params[:ratings]
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


  def inject_if_missing_params(params, session)
    inject_params = Hash.new

    # fill missing sort with session
    if (params[:sort].nil? and !session[:sort].nil?)
      inject_params[:sort] = session[:sort]

      # note if params ratings in null it will go
      # through here again
      inject_params[:ratings] = params[:ratings]
    end

    #fill missing rating with session
    if (params[:ratings].nil? and !session[:ratings].nil?)
      # note if params sort in null it will go
      # through here again
      inject_params[:sort] = params[:sort]
      inject_params[:ratings] = session[:ratings]
    end

    return inject_params
  end


end
