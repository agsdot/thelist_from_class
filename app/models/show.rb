class Show < ActiveRecord::Base
  attr_accessible :bands, :date, :misc, :venue
end

require 'nokogiri'
require 'open-uri'

class Extractor

  def initialize
    url = "https://dl.dropboxusercontent.com/u/14675889/thelist.html"
    @url_data = Nokogiri::HTML(open(url))
  end

  def dates

    @date = []
    @dates = []
    @num = 0
    @count = []

    @url_data.xpath('//ul/li/ul').each do |i|
      @num = i.css('b').count
      @count << @num
    end

    @url_data.xpath('//ul/li/a/b').each do |date|
      @date << date.text + ','
    end

    7.times do |i|
      @dates << (@date[i] * @count[i]).split(',')
    end

    @dates.flatten!
  end

  def venues

    @venues = []

    @url_data.css("li").css("b").css("a").each do |ven|
      @venues << ven.text
    end
    return @venues
  end

  def bands

    @bands = []
    @bands_line = []

    @url_data.css('b').remove

    @url_data.css("ul li ul li").each do |line|
      line.css('a').collect do |band|
        @bands_line << band.text
      end
      @bands << @bands_line
      @bands_line = []
    end
    return @bands
  end

  def misc
    @misc = []

    @url_data.css('a').remove

    @url_data.css("ul li ul li").each do |misc|
      @misc << misc.text.gsub(/\,/,"").split(" ")
    end
    return @misc

  end
end

class InputShowData

def initialize
  e = Extractor.new
  @dates = e.dates
  @venues = e.venues
  @bands = e.bands
  @misc = e.misc
end

def input_arrays
  @dates.size.times do |i|
    Show.create(:date => @dates[i], :venue => @venues[i], :bands => @bands[i].join(", "),
      :misc => @misc[i].join(", "))
  end
end

end