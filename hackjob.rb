require 'socket'
require 'io/console'

def authen
  @socket.sendmsg("NICK #{@nick}\r\n",0)
  @socket.sendmsg("USER testUserDude 8 #{`hostname`.chomp} : Test User\r\n",0)
end

def join_channel channel
  @current_channel = channel.gsub(/^\/\w+/,'')
  @socket.sendmsg("JOIN #{@current_channel}\r\n",0)
end

def quit
  sleep 5
  $stdout.print "Goodbye :("
  @socket.close
  @threads.each{|thr| thr.kill} 
end

def parse_it command
  extracted_command = command.match(/^\/\w+/)[0].upcase.gsub(/\//,'')
  message_string    = command.gsub(/^\/\w+/,"")
  return extracted_command, message_string
end

def run_command command
  extracted_command, message_string = parse_it(command)
  @socket.sendmsg("#{extracted_command} #{message_string}\r\n",0)
  quit if extracted_command == "QUIT"
end

def send_privmsg input
  str_to_send = "PRIVMSG #{@current_channel} :#{input}".gsub(/\n/,'')
  @socket.send("#{str_to_send}\r\n\r\n",0)
end

def process_input(input)
  if input =~ /(^\/join|^\/j)/
    join_channel(input)
  elsif input=~ /^\//
    run_command(input)
  else
    send_privmsg(input)
  end
end

def pong(msg)
  server = msg.gsub(/PING :/,'')
  @socket.send("PONG #{server}\r\n",0)
end


def color_text(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def red(text)
  color_text(text, 31)
end

def yellow(text)
  color_text(text, 33)
end

def cyan(text)
  color_text(text, 36)
end

def check_input
  $stdin.each_line do |line|
    $stdout.print "#{red(@nick)}: "
    process_input(line.chomp)
  end
end

def start
  $stdout.print red("Welcome to vadeRC - an IRC client written in Ruby\n")
  $stdout.print "Please enter a server address: "
  @server = gets.chomp
  $stdout.print "Please enter desired nick: "
  @nick = gets.chomp
end

def main_loop
  while line = @socket.gets
    print cyan(line)
    authen if line =~ /Found your/
    pong(line) if line =~ /PING/
  end
end

$stdout.sync = true

start

@socket = TCPSocket.new(@server, 6667)
@current_channel = ''

@threads = []
@threads << Thread.new{ main_loop }
@threads << Thread.new{ check_input }
@threads.each{ |thr| thr.join }

