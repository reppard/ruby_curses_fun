class Session
  attr_accessor :realname, :username, :current_channel, :nick, :channels, :mode
  def initialize config
    @username = config['username']
    @nick = config['default_nick']
    @mode = config['mode']
    @realname = config['realname']
    @channels =[]
  end
end

