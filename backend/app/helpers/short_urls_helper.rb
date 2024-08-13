module ShortUrlsHelper

	BASE62_CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

	def base62_encode(n)
		# Encodes a numeric value into a base62 string.
		# @param n [Numeric] the number to be encoded.
		# @return [String, nil] the base62 encoded string or nil if input is invalid.
		# Convert the number to base62 by repeatedly dividing and finding the remainder,
		# and appending the corresponding base62 character
		
		return unless n.is_a?(Numeric) && !n.nil? 
    return '0' if n == 0

		short_alias = '' 
			
		while n > 0 do 

			short_alias << BASE62_CHARACTERS[n % 62]
			n /= 62 
		end

		short_alias.reverse 
	end


  def base62_decode(str)
		# Decodes a base62 string back into a numeric value.
    # @param str [String] the base62 encoded string.
    # @return [Numeric, nil] the decoded numeric value or nil if input is invalid.
    
    return unless str.is_a?(String) && !str.nil?

    n = 0

    str.each_char do |char|
      value = BASE62_CHARACTERS.index(char)
      return nil if value.nil?
      n = n * 62 + value
    end

    n 
	end

	def is_valid_url(full_url)
		# Validates if the given URL is properly formatted.
		# @param [String] full_url The URL to validate.
		# @return [Boolean] Returns true if the URL is valid, false otherwise.
		
		url = full_url.to_s.strip.downcase
		!!(url=~/^(ftp|http|https):\/\/[^ "]+$/)
	end
end
