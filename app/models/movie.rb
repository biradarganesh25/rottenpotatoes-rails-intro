class Movie < ActiveRecord::Base
    def self.get_ratings
        return ["G","PG", "PG-13", "R"]
    end

    def self.filter_movies_by_ratings ratings
        return self.where(rating: ratings.keys)
    end
end
