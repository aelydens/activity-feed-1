require "json"
require "pry"

class ActivityParser
  def initialize
    p "initializing"
    @feed_data = JSON.parse(File.open("data/feed_entries.json").read)
  end

  def get_events
    string = ""
    @feed_data.each do |obj|
      string << "#{obj["objects"]["creator"]["text"]} added a #{obj["objects"]["address"]["text"]} to #{obj["objects"]["patient"]["text"]}\n"
    end
    string
  end

  def write_data
    File.open("lib/activity_feed.md", 'w') { |file| file.write(self.get_events) }
  end
end

test = ActivityParser.new
test.write_data


#opens activity_feed.md
#for each event from feed_entries.json
    #pull in URL based on object id from objects.json
#writes a sentence in md file -- formatting!
#save file
#closes file
