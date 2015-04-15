class MiniKick
  def run
    welcome_message
    call
  end

  def call
    print ">> "
    input = gets.strip
    ParseInput.new(input)
  end

  def welcome_message
    print "Welcome to MiniKick! You can start a project, back a project, check out what projects backers have backed, and more!\n"
  end
end

