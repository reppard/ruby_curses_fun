require_relative 'lib/window'

class VadeRC
  def self.run
    begin
      @mainwindow = Window.new
      @mainwindow.listen_to_input
    ensure
      close_screen
    end
  end
end


VadeRC.run
