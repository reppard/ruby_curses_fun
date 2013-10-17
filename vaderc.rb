require_relative 'lib/window'
require 'socket'

class SocketReader
  attr_accessor :socket, :window

  def initialize server, port, window
    @window = window
    @socket = TCPSocket.new(server, port)
  end

  def read_from_server
    Thread.new do
      while line = @socket.gets
        @window.mainContent.addstr("#{line.chomp}\n") if !line.nil?
        @window.mainContent.refresh
      end
    end
  end
end

class SocketWriter
  attr_reader :input_stream

  def initialize socket, window
    @socket = socket
    @window = window
    @input_stream = Thread.new{ read_from_client }
  end

  def read_from_client
    loop do
      line = @window.inputSpace.getstr
      @socket.sendmsg("#{line.chomp}\r\n",0)
      @window.inputSpace.clear
      @window.mainContent.refresh
    end
  end

end

class VadeRC
  def self.run
      @mainwindow = Window.new
      @socketreader = SocketReader.new("irc.freenode.net",6667,@mainwindow)
      @socketwriter = SocketWriter.new(@socketreader.socket,@mainwindow)

      @socketreader.read_from_server.join
      @socketwriter.input_stream.join
  end
end


VadeRC.run
