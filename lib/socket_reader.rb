require 'socket'

class SocketReader
  attr_accessor :socket, :window

  def initialize server, port, window
    @window = window
    @socket = TCPSocket.new(server, port)
    @message_handler = MessageHandler.new @window.mainContent
  end

  def read_from_server
    Thread.new do
      while line = @socket.gets
        handle_message(line) if line
        authen     if line =~ /hostname/
        pong(line) if line =~ /PING/
        @window.mainContent.refresh
      end
    end
    ensure
      @window.mainFrame.close && @socket.close
  end

  def pong(line)
    server = line.gsub(/PING :/,'')
    @socket.send("PONG #{server}\r\n",0)
  end

  def authen
    @socket.sendmsg("NICK #{SESSION.nick}\r\n",0)
    @socket.sendmsg("USER #{SESSION.username} #{SESSION.mode} #{`hostname`.chomp} : #{SESSION.realname}\r\n",0)
  end

  def handle_message(line)
    @message_handler.process(line)
  end
end
