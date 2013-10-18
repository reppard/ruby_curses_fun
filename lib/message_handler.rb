class MessageHandler
  attr_reader :target
  def initialize target
    @target = target
  end

  def process(line)
    msg = Message.new line
    print_parsed(msg)
    @target.refresh
  end

  def print_parsed msg
    @target.addstr(msg.format)
  end

  def print_unparsed message_array,code
    @target.addstr(code+message_array.join(' ')+"\n")
  end
end

