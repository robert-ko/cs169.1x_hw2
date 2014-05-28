class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date

  def self.all_ratings
    Movie.pluck(:rating).uniq.sort
  end


  def self.all_filter_on_ratings ratings
    Movie.where(rating: ratings)
  end

 end
