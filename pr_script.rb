# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'httparty'
  gem 'prometheus-client'
end

vets_web_prs = 'https://api.github.com/repos/department-of-veterans-affairs/vets-website/pulls?state=open&per_page=100'
vets_api_prs = 'https://api.github.com/repos/department-of-veterans-affairs/vets-api/pulls?state=open&per_page=100'

vets_web_response = HTTParty.get(vets_web_prs)
vets_api_response = HTTParty.get(vets_api_prs)

all_responses = vets_web_response | vets_api_response
response_keys = ['id','number','created_at','updated_at','head']
open_prs = []

all_responses.each do |response|
  h = {}
	response.each do |k,v|
    next unless response_keys.include?(k)
    if k == 'head'      
      h["repo"] = "#{v['repo']['name']}"
    else
      h["#{k}"] = "#{v}"
    end
  end
  open_prs << h
end

puts open_prs
