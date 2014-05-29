class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date

  def self.all_ratings
    Movie.pluck(:rating).uniq.sort
  end


  def self.all_filter_on_ratings ratings
    Movie.where(rating: ratings)
  end


  def self.sort_and_filter( sort, ratings)

    # check for sort
    # ratings should always be there
    if !sort.nil?
      Movie.where(rating: ratings).order(sort).uniq
    else
      Movie.where(rating: ratings).uniq
    end

  end


 end
