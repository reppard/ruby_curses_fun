class Command
  attr_accessor :line, :socket, :payload
  CONFIG = YAML.load_file("commands.yaml")
  def initialize line, socket
    @line = line.chomp
    @socket = socket
    @payload = is_command? ? process_command : @line
  end

  def is_command?
    @line[0] == "/" && CONFIG.has_key?(stripped_cmd)
  end

  def process_command
    cmd_alias, *body = @line.split(' ')
    "#{CONFIG[stripped_cmd]['command']} #{body.join(' ')}"
  end

  def stripped_cmd
    @line.split(' ').first.gsub(/^\//,'').upcase
  end
end

