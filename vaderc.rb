require 'yaml'
require_relative 'lib/window'
require_relative 'lib/socket_reader'
require_relative 'lib/socket_writer'

class VadeRC
  def self.run set_config
      config = YAML.load_file("config.yaml")
      server = config[set_config]['server']
      port = config[set_config]['port']

      @mainwindow = Window.new
      @socket_reader = SocketReader.new(server,port,@mainwindow)
      @socket_writer = SocketWriter.new(@socket_reader.socket,@mainwindow)

      @socket_reader.read_from_server.join
      @socket_writer.input_stream.join
  end
end


VadeRC.run ARGV[0]
