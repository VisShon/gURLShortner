require 'uri'
require_relative "../helpers/short_urls_helper"
include ShortUrlsHelper

class ShortUrlsController < ApplicationController

	# Since we're working on an API, we don't need to verify authenticity tokens.
	skip_before_action :verify_authenticity_token

	def index
		# GET /
		# @return [JSON] Returns the top 100 URLs ordered by click_count in JSON format.
		begin
			top_urls = find_top_urls
			render json: { urls: top_urls }, 
      status: OK
		rescue => err
			render json: { error: "Internal Server Error: #{err.message}" }, 
			status: INTERNAL_SERVER_ERROR
		end
		
	end

	def show
		# GET /:id
		# @param [String] full_url The full URL to be retrieved.
		# @return [Redirect] Redirects to the original full URL.
  
		begin
			short_code = strong_params(:id)
      record = ShortUrl.find_by_short_code(short_code)
    
			if record.nil?
				render json: "Not Found", 
				status: NOT_FOUND and return
			end

			impression_click_count(record)

			redirect_to record.full_url,  
			status: REDIRECT_URL,
      allow_other_host: true

		rescue => err
			render json: { error: "Internal Server Error: #{err.message}" }, 
			status: INTERNAL_SERVER_ERROR
		end

	end

	def create
		# POST /short_urls
		# @param [String] full_url The full URL to be shortened.
		# @return [String] Returns a plain text "OK" if the URL is successfully created.
		begin
			req_full_url = strong_params(:full_url)
			url = URI.parse(req_full_url.gsub('\\', ''))

			url_shortner = ShortUrl.new(full_url: url.to_s)

			if url_shortner.save
				url_shortner.update_title!
				render json: { short_code: url_shortner.short_code }, status: OK
			else
				render json: {errors:url_shortner.errors.full_messages}, 
        status: UNPROCESSABLE_CONTENT
			end

		rescue => err
			render json: { 
				error: "Internal Server Error: #{err.message}" 
			}, status: INTERNAL_SERVER_ERROR
		end
	end

	def update
		# PATCH /short_urls
		# @param [String] full_url The current full URL to be updated.
		# @param [String] new_url The new URL to replace the existing one.
		# @return [JSON] Returns the updated URL record in JSON format.
		
		begin
			req_id = strong_params(:id)
			record = ShortUrl.find_by(
				id: req_id
			)

			req_new_url = strong_params(:new_url)
			url = URI.parse(req_new_url.gsub('\\', ''))

			if record.nil?
				render json: {
				  error: "Record Not Found",
				  reason: "The URL you are trying to update does not exist."
				}, status: NOT_FOUND and return
			end


			if record.update( full_url: url.to_s)
				record.update_title!
				render json: {
					response: "Record Created", 
					short_code: record.short_code
				}, status: OK

			else
				render json: {
					error: "Record Not Updated", 
					reason: record.errors.full_messages
				}, status: UNPROCESSABLE_CONTENT

			end


		rescue => err
			render json: { 
				error: "Internal Server Error: #{err.message}" 
			}, status: INTERNAL_SERVER_ERROR
		end
	end

	def destroy
		# DELETE /short_urls
		# @param [String] full_url The full URL to be deleted.
		# @return [String] Returns a plain text "Deleted" if the URL is successfully destroyed.
		
		begin
			req_id = strong_params(:id)
			record = ShortUrl.find_by(
				id: req_id
			)

			if record.nil?
				render json: {
					error: "Record Not Found",
					reason: "The URL you are trying to update does not exist."
				}, status: NOT_FOUND and return
			end


			if record.destroy
				render json: {
					response: "Record Deleted", 
				}, status: OK

			else
				render json: {
					error: "Record Not Deleted", 
					reason: record.errors.full_messages
				}, status: UNPROCESSABLE_CONTENT

			end
			
		rescue => err
			render json: { 
				error: "Internal Server Error: #{err.message}" 
			}, status: INTERNAL_SERVER_ERROR

		end
	end

	private

	def strong_params(url_param)
		# Strong parameters to whitelist the allowed parameters.
		# @param [Symbol] url_param The parameter to be whitelisted.
		# @return [String] Returns the whitelisted parameter value.
		params.require(url_param)
	end

	def impression_click_count(url_record)
		# Increments the impression click_count for a given URL record.
		# @param [ShortUrl] url_record The URL record whose click_count will be incremented.
		# @return [Boolean] Returns true if the update was successful.
		url_record.increment!(:click_count)
	end

	def find_top_urls
		# Finds the top 100 URLs ordered by their click_count in descending order.
		# @return [ActiveRecord::Relation] Returns a collection of the top 100 URLs.
		ShortUrl.order(
			click_count: :desc
		).limit(100)
	end

end
