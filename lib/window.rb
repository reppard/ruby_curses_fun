require 'curses'
require 'io/console'

class Window
  attr_accessor :mainFrame, :mainContent, :nickFrame,
                :nickContent, :inputFrame, :inputSpace

  def initialize
    rows, columns = $stdin.winsize
    @socket = ""
    @mainFrame   = Curses::Window.new(rows, columns, 0, 0)
    @mainContent = @mainFrame.subwin(rows - 4, columns - 26, 1, 3)
    @nickFrame   = @mainFrame.subwin(rows - 4, 20, 1, columns - 22)
    @nickContent = @mainFrame.subwin(rows - 6, 18, 2, columns - 21)
    @inputFrame  = @mainFrame.subwin(3, columns, rows - 3, 0)
    @inputSpace  = @mainFrame.subwin(1, columns-2, rows - 2, 1)
    @mainContent.scrollok(true)
    @inputSpace.scrollok(true)

    add_borders([@mainFrame,@nickFrame,@inputFrame])
    @mainFrame.refresh
  end

  def add_borders frames
    frames.each do |frame|
      frame.box("|","-")
    end
  end
end
