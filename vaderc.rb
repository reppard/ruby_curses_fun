require 'yaml'
Dir["lib/*.rb"].each{|file| require_relative file}

class VadeRC
  def self.run config
      @mainwindow = Window.new
      @socket_reader = SocketReader.new(config['server'],config['port'],@mainwindow)
      @socket_writer = SocketWriter.new(@socket_reader.socket,@mainwindow)

      @socket_reader.read_from_server.join
      @socket_writer.input_stream.join
  end

  def self.blow_up
    puts "usage: ruby vaderc.rb <config-name>"
    puts "\nThe current available options are:"
    CONFIG.each_key do |config|
      puts "    #{config}"
    end
    puts "\nTo add a server configuration, add it to 'config.yaml'."
    exit
  end
end

config_op = ARGV[0]

CONFIG = YAML.load_file("config.yaml")

VadeRC.blow_up if config_op.nil? || !CONFIG.has_key?(config_op)

SESSION = Session.new CONFIG[config_op]['user']

VadeRC.run CONFIG[config_op]
