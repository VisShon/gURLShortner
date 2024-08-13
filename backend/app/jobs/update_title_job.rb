require 'nokogiri'
require 'open-uri'
require 'concurrent'

class UpdateTitleJob < ApplicationJob
  queue_as :default

  def perform(short_url_id)
    # Perform the job to update the title of a ShortUrl record.
    # @param [Integer] short_url_id The ID of the ShortUrl record to update.
      
    record = ShortUrl.find_by(id: short_url_id)
    return p "Record not found: #{short_url_id}" unless record

    begin
      promise = Concurrent::Promise.execute {
        URI.open(record.full_url) { |file|
			Nokogiri::HTML(file).at_css('title')&.text 
		}
      }

      promise.then do |html_title| 
        html_title ? 
		record.update(title: html_title) && p("title found #{html_title}"): 
		p("Title tag not found for URL: #{record.full_url}")
      end.wait

    rescue => e
      p "An error occurred: #{e.message}"
    end
  end
end
