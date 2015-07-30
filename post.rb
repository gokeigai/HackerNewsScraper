class Post

  attr_reader :title, :url, :points, :item_id
  @@comments = []
  
  def initialize(post_title, post_url, post_points, post_item_id)
    @title = post_title
    @url = post_url
    @points = post_points
    @post_item_id = post_item_id
  end

  def comments
    @@comments
  end

  def add_comment(comment)
    #add parsed comments to @@comments
    @@comments.push(comment)
  end

end