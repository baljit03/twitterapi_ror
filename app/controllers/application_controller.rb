class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
require "base64"
require "json"
require "net/http"
require "net/https"
require "uri"


# for posting tweet on twitter
def save
	### Setup access credentials

	consumer_key = "Ne39dP6TPxfb9ZskLzGdfb4DA"
	consumer_secret = "JcrVnSS9lg31qALsIW8bEsISeirtXVBBfT0QqWJxJgORurfU5d"

	### Get the Access Token

	bearer_token = "#{consumer_key}:#{consumer_secret}"
	bearer_token_64 = Base64.strict_encode64(bearer_token)

	token_uri = URI("https://api.twitter.com/oauth2/token")
	token_https = Net::HTTP.new(token_uri.host,token_uri.port)
	token_https.use_ssl = true

	token_request = Net::HTTP::Post.new(token_uri)
	token_request["Content-Type"] = "application/x-www-form-urlencoded;charset=UTF-8"
	token_request["Authorization"] = "Basic #{bearer_token_64}"
	token_request.body = "grant_type=client_credentials"

	token_response = token_https.request(token_request).body
	#@timeline_json = token_response

	token_json = JSON.parse(token_response)

	access_token = token_json["access_token"]
	#puts access_token
	#@timeline_json = access_token
	### Use the Access Token to make an API request


	timeline_uri = URI("https://api.twitter.com/1.1/statuses/update.json?screen_name=testingclient1")
	timeline_https = Net::HTTP.new(timeline_uri.host,timeline_uri.port)
	timeline_https.use_ssl = true

	timeline_request = Net::HTTP::Post.new(timeline_uri)
	#@timeline_json = timeline_request
	timeline_request["Authorization"] = "Bearer #{access_token}"
	timeline_request["Content-Type"] = "application/json;charset=UTF-8"
	timeline_request["status"] = "testing tweet"
	timeline_response = timeline_https.request(timeline_request).body
	timeline_json = JSON.parse(timeline_response)

	puts JSON.pretty_generate(timeline_json)
	@timeline_json = timeline_json
  end

# for fetching the tweet
def load_tweet
	### Setup access credentials

	consumer_key = "i6baQCTt1sCXAo8YWcKhuly9Z"
	consumer_secret = "DeE9vnnlt7uLgvb1k7ymuHkhBMA0WlOLhSOXzSZAPrO0HZb63h"

	### Get the Access Token

	bearer_token = "#{consumer_key}:#{consumer_secret}"
	bearer_token_64 = Base64.strict_encode64(bearer_token)

	token_uri = URI("https://api.twitter.com/oauth2/token")
	token_https = Net::HTTP.new(token_uri.host,token_uri.port)
	token_https.use_ssl = true

	token_request = Net::HTTP::Post.new(token_uri)
	token_request["Content-Type"] = "application/x-www-form-urlencoded;charset=UTF-8"
	token_request["Authorization"] = "Basic #{bearer_token_64}"
	token_request.body = "grant_type=client_credentials"

	token_response = token_https.request(token_request).body
	token_json = JSON.parse(token_response)

	access_token = token_json["access_token"]

	### Use the Access Token to make an API request

	timeline_uri = URI("https://api.twitter.com/1.1/statuses/home_timeline.json")
	timeline_https = Net::HTTP.new(timeline_uri.host,timeline_uri.port)
	timeline_https.use_ssl = true

	timeline_request = Net::HTTP::Get.new(timeline_uri)
	timeline_request["Authorization"] = "Bearer #{access_token}"

	timeline_response = timeline_https.request(timeline_request).body
	timeline_json = JSON.parse(timeline_response)

	puts JSON.pretty_generate(timeline_json)
	@timeline_json = timeline_json


end
