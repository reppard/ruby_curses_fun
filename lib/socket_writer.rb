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
      @socket.sendmsg("#{line.chomp}\r\n",0) if !@socket.closed?
      @window.inputSpace.clear
      @window.mainContent.refresh
    end
  end

end
