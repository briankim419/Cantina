require 'httparty'
require 'pry'
require 'pp'

url = 'https://raw.githubusercontent.com/jdolan/quetoo/master/src/cgame/default/ui/settings/SystemViewController.json'
response = HTTParty.get(url)
json_response = JSON.parse(response.body)
@data = json_response
@all_responses = []
@selector = nil
@id = nil


puts "Input class, classNames, or identifier as a simple selector. Compound selectors and Selector chains are also supported."
input = gets.chomp

if input.include?("#")
  parsed_input = input.split("#")
  @selector = parsed_input[0]
  @id = parsed_input[1]
  if parsed_input[0] == ""
    @selector = "identifier"
  end
elsif input.include?(".")
  parsed_input = input.split(".")
  @selector = parsed_input[0].strip
  @id = parsed_input[1]
  if parsed_input[0].strip == ""
    @selector = "classNames"
  end
else
  @selector = input
end

def search (obj, term)
  if obj.class == Hash
    if !obj.values.include?(term)
      obj.each do |data_set|
        if data_set.class == Array
          if !data_set.include?(term)
            if data_set.class != String
              search(data_set, term)
            end
          else
            if @id != nil

              term = @id
              search(data_set, term)
              @id = nil
            else
              @all_responses << obj
            end
          end
        else
          if !data_set.include?(term)
            search(data_set, term)
          else
            if @id != nil
              term = @id
              search(data_set, term)
              @id = nil
            else
              @all_responses << data_set
            end
          end
        end
      end
    end
  else
    if !obj.include?(term)
      obj.each do |data_set|
        if data_set.class == Array
          if !data_set.include?(term)
            if data_set.class != String
              search(data_set, term)
            end
          else
            if @id != nil
              term = @id
              search(data_set, term)
              @id = nil
            else
              @all_responses << obj
            end
          end
        else
          if data_set.class == Hash
            if !data_set.values.include?(term)
              search(data_set, term)
            else
              if @id != nil
                term = @id
                search(data_set, term)
                @id = nil
              else
                @all_responses << data_set
              end
            end
          end
        end
      end
    end
  end
end

search(@data, @selector)

puts "Number of responses"
puts @all_responses.length

puts "RESPONSE"
puts "======="
@all_responses.each do |response|
  puts pp(response)
end
