require "json"
require "pry"

class ActivityParser
  def initialize(feed_data, object_data)
    @feed_data = feed_data
    @object_data = object_data
  end

  def get_events
    string = ""
    @feed_data.each do |obj|
      if get_url_for_creator(obj["objects"]["creator"]["id"])
        string << "[#{obj["objects"]["creator"]["text"]}]"
      else
        string << "#{obj["objects"]["creator"]["text"]} "
      end
      string << "#{get_url_for_creator(obj["objects"]["creator"]["id"])}"
      
      if get_url_for_address(obj["objects"]["address"]["id"])
        string << "added [#{obj["objects"]["address"]["text"]}]"
      else
        string << "added #{obj["objects"]["address"]["text"]} "
      end
      string << "#{get_url_for_address(obj["objects"]["address"]["id"])}"

      if get_url_for_patient(obj["objects"]["patient"]["id"])
        string << "to [#{obj["objects"]["patient"]["text"]}]"
      else
        string << "to #{obj["objects"]["patient"]["text"]}"
      end
      string << "#{get_url_for_patient(obj["objects"]["patient"]["id"])}"
      string << "\n\n"
    end
    string
  end

  def get_url_for_creator(id)
    if @object_data["User"].map {|x| x["id"] }.include?(id)
      "(#{@object_data["User"].select {|x| x["id"] == id }[0]["url"]}) "
    end
  end

  def get_url_for_address(id)
    if @object_data["Address"].map {|x| x["id"] }.include?(id)
      "(#{@object_data["Address"].select {|x| x["id"] == id }[0]["url"]}) "
    end
  end

  def get_url_for_patient(id)
    if @object_data["Patient"].map {|x| x["id"] }.include?(id)
      "(#{@object_data["Patient"].select {|x| x["id"] == id }[0]["url"]}) "
    end
  end

  def write_data
    File.open("lib/activity_feed.md", 'w') { |file| file.write(self.get_events) }
  end
end

feed_data = JSON.parse(File.open("data/feed_entries.json").read)
object_data = JSON.parse(File.open("data/objects.json").read)

test = ActivityParser.new(feed_data, object_data)
test.write_data
