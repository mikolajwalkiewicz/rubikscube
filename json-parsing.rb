#!/usr/bin/env ruby
# List cookbook's version for the given environment in Chef

# Library for parsing json
require 'json'


Dir.glob('./*.json') do |jfile|
    puts "ENVIRONMENT: #{jfile.sub('./', '').sub('.json', '')}"
    file = open(jfile)
    json = file.read

    parsed = JSON.parse(json)

    parsed["cookbook_versions"].each do |y, x|
        puts y.ljust(30, ' ') + "\t" + x.gsub(/(=|>|<|>=|<=|->| )/, '')
    end
    puts "\n"
end