require_relative "../helpers/short_urls_helper"
include ShortUrlsHelper

class ShortUrl < ApplicationRecord
	
	# Validate the presence and uniqueness of the full_url field.
	# Also, validate the URL format using a custom validation method.

	validates :full_url, presence: true, uniqueness: true
	validate :validate_full_url, on: [:save, :create, :update]

  def self.find_by_short_code(short_code)
    # Decode the number from base62-encoded short code.
    # @return [Number] the base62-decoded number.
    return nil if short_code.nil?
    record = ShortUrl.find_by(
				id: base62_decode(short_code)
		)
    return record
  end

	def public_attributes
    return {
      "id"=> self.id,
      "full_url"=> self.full_url,
      "title"=> self.title,
      "click_count"=> self.click_count,
      "created_at"=> self.created_at&.strftime('%Y-%m-%dT%H:%M:%S.%LZ'),
      "updated_at"=> self.updated_at&.strftime('%Y-%m-%dT%H:%M:%S.%LZ'),
    }
	end

	def short_code
		# Generates a base62-encoded short code from the given ShortURL id.
		# @return [String] the base62-encoded short code.
    return nil if self.full_url.nil?
		base62_encode(self.id)
	end

	def update_title!
		# Enqueue the UpdateTitleJob to run in the background, 
        # passing the current record's ID
		UpdateTitleJob.perform_now(self.id)
	end

	private

	def validate_full_url
		# Validates the format of the full_url attribute.
		# Adds an error to the base if the URL is invalid.

		validity = is_valid_url(self.full_url)
		errors.add(:full_url, "is not a valid url") unless validity
	end
	

end
