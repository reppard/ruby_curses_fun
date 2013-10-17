class MessageHandler
  attr_reader :target
  def initialize target
    @config = YAML.load_file("messages.yaml")
    @target = target
  end

  def process(line)
    extracted = line.chomp.split(' ')
    code = extracted[1]
    @config[code] ? eval("display_#{@config[code]['type']}(extracted,code)")
                  : display_default(extracted,code)
    @target.refresh
  end

  def display_default message_array,code
    (message_array.size >= 3) ? @target.addstr(code+message_array[3..-1].join(' ')+"\n")
                              : @target.addstr(code+message_array.join(' ')+"\n")
  end

  def display_NOTICE message_array,code
    @target.addstr(code+message_array[3..-1].join(' ')+"\n")
  end

  def display_RPL_MOTD message_array,code
    @target.addstr(code+message_array[3..-1].join(' ')+"\n")
  end

end
