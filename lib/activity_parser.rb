require "json"
require "pry"

class ActivityParser
  def initialize
    p "initializing"
    @feed_data = JSON.parse(File.open("data/feed_entries.json").read)
    @object_data = JSON.parse(File.open("data/objects.json").read)
  end

  def get_events
    string = ""
    @feed_data.each do |obj|
      string << "#{obj["objects"]["creator"]["text"]} "
      string << "#{get_url_for_creator(obj["objects"]["creator"]["id"])}"
      string << "added #{obj["objects"]["address"]["text"]} "
      string << "#{get_url_for_address(obj["objects"]["address"]["id"])}"
      string << "to #{obj["objects"]["patient"]["text"]}"
      string << " #{get_url_for_patient(obj["objects"]["patient"]["id"])}"
      string << "\n"
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

test = ActivityParser.new
test.write_data
