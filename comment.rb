class Comment

  attr_reader :author, :content

  def initialize(comment_author, comment_content)
    @author = comment_author
    @content = comment_content
  end

end