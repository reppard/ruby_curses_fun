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
        authen     if line =~ /Found your hostname/
        pong(line) if line =~ /PING/
        @window.mainContent.refresh
      end
    end
  end

  def pong(line)
    server = line.gsub(/PING :/,'')
    @socket.send("PONG #{server}\r\n",0)
  end

  def authen
    @socket.sendmsg("NICK vadercUser\r\n",0)
    @socket.sendmsg("USER testUserDude 8 #{`hostname`.chomp} : Test User\r\n",0)
  end
end
