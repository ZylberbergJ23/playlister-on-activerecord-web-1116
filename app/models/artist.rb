class Artist < ActiveRecord::Base
	has_many :songs
	has_many :genres, through: :songs

	# def full_name
		
	# end

	# def add_genre(genre)
		
	# end
end
