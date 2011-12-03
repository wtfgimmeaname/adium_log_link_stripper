require 'rubygems'
require 'rexml/document'

class Relinkwish
  @link_arr = []
  @file_arr = []

  def initialize
    puts "This tool is for removing urls from xml based chat logs"
  end

  def extract_links(line)
    line.scan(/href="(.*?)"/).flatten
  end

  def strip
    filetypes = File.join("**", "*.xml")
    @file_arr = Dir.glob(filetypes)
    pull_all_urls(@file_arr)
  end

  def pull_all_urls(read_these)
    all_file_links = []
    read_these.each do |f|
      file = IO.read(f)
      file_links = file.scan(/href=".*?"/)
      file_links.each do |url|
        if url.include? "mint.com"
          file_links.delete(url)
        end
      end
      all_file_links << file_links
    end
    @link_arr = all_file_links.flatten.uniq
    puts "Complete! You can view_a_url(#) or see how_many"
    puts "To render the link array to a file, run build_link_file"
  end

  def build_link_file
    file = File.open("links.html", "w+")
    file.puts("<html><head></head><body>")
    counter = 0
    while counter < @link_arr.count
      alink = view_a_url(counter)
      final_link = "<a href=\"#{alink}\" target=\"_blank\">#{alink}</a><br />"
      file.puts(final_link+"\n")
      counter += 1
    end
    file.puts("</body></html>")
    file.close
    puts "File links.html is built"
  end

  def how_many?
    return @link_arr.count
  end

  def view_a_url(num)
    viewing = @link_arr[num]
    viewing.gsub("href=\"", "").chomp("\"")
  end

  def output_messages_by_file_by_id(file_id)
    traversable = REXML::Document.new(file)
    chat = traversable.root
    puts "FROM: #{chat.attributes["service"]}"
    puts "----------------------------------"
    puts chat.elements["message"].attributes["sender"]
    traversable.elements.each("message") do |msg|
      puts "#{msg.atrributes["sender"]} said __ :: __ #{msg}"
    end
  end

end
