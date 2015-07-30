require 'nokogiri'
require 'colorize'
require 'open-uri'

require './post.rb'
require './comment.rb'
require './scrape_error.rb'

include ScrapeError

url = ARGV.shift
html_file = ""

begin
  html_file = open(url)
rescue SocketError
  puts "Sorry couldn't find the web page"
  exit
end

begin
  doc = Nokogiri::HTML(File.open(html_file))
rescue Errno::ENOENT
  puts "Sorry couldn't grab the file."
  exit
end

title = doc.css('.title').inner_text
score = doc.css('.subtext .score').inner_text

# Possible Result: ["item?id=7663775"]
item_id = doc.search('.subtext > a:nth-child(3)').map {|link| link['href'] }[0].split("=")[1] 

topic_url = doc.css('.title > a')[0]['href']

begin
  if title.empty? || score.empty? || item_id.empty? || topic_url.empty?
    raise InvalidPost, "Post must have a title, score, item id, or topic url"
  end
rescue InvalidPost => e
  puts e.message
  exit
end

post = Post.new(title, topic_url, score, item_id)

authors = doc.search('.comhead > a:first-child').map { |element| element.inner_text }

comments = doc.search('.comment').map { |element| element.inner_text }

for i in 0..comments.size-1

  begin
    if authors[i].empty? || comments[i].empty?
      raise InvalidComment, "Comment must have an author and content"
    end
  rescue InvalidComment => e
    puts e.message
    exit
  end

  tmp_comment = Comment.new(authors[i],comments[i])
  post.add_comment(tmp_comment)
end

all_comments = post.comments
puts "============================================================"
puts ""
puts "Url: " << topic_url.colorize(:cyan)
puts "Item Id: " << item_id.colorize(:magenta)
puts "Number of Comments: " << all_comments.size.to_s.colorize(:green)
puts ""
puts "==========================================================="
puts ""

puts "Comments:"
all_comments.each {|comment|
  puts comment.author.colorize(:blue)
  puts comment.content
}







