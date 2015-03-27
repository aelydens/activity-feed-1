require 'spec_helper'
require 'json'
require_relative '../lib/activity_parser'

describe ActivityParser do
  before {
    feed_data = JSON.parse(File.open("data/test_feed_entries.json").read)
    object_data = JSON.parse(File.open("data/objects.json").read)
    @test_parser = ActivityParser.new(feed_data, object_data)
  }

  it "should return expected string when given json data" do
    expect(@test_parser.get_events).to eq(
      "[Geoffrey Lesch](http://example.com/users/2365) added [a business address](http://example.com/addresses/17174) to Emilie Lind\n\nJefferey Dibbert added a vacation address to [Stacey Marvin](http://example.com/patients/9681) \n\n"
    )
  end
end
