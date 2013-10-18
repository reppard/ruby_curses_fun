require 'yaml'
Dir["lib/*.rb"].each{|file| require_relative file}
class Session
  attr_accessor :user, :current_channel, :nick
end

SESSION = Session.new

class VadeRC
  def self.run set_config
      @config = YAML.load_file("config.yaml")
      blow_up if set_config.nil? || !@config.has_key?(set_config)

      SESSION.user = @config[set_config]['user']
      server = @config[set_config]['server']
      port = @config[set_config]['port']

      @mainwindow = Window.new
      @socket_reader = SocketReader.new(server,port,@mainwindow)
      @socket_writer = SocketWriter.new(@socket_reader.socket,@mainwindow)

      @socket_reader.read_from_server.join
      @socket_writer.input_stream.join
  end

  def self.blow_up
    puts "usage: ruby vaderc.rb <config-name>"
    puts "\nThe current available options are:"
    @config.each_key do |config|
      puts "    #{config}"
    end
    puts "\nTo add a server configuration, add it to 'config.yaml'."
    exit
  end
end


VadeRC.run ARGV[0]
