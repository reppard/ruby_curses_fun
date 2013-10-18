class Message
  attr_reader :extracted, :format
  CONFIG = YAML.load_file("messages.yaml")

  def initialize line
    @extracted = line.split(' ')
    @from   = @extracted[0]
    @code   = @extracted[1]
    @to     = @extracted[2]
    @format = get_format
  end

  def get_format
    if has_format?
      format = CONFIG[@code]['format']
      format.each do |entry|
        if entry.class == String
          range = entry.split('..').map{|d| d.to_i}
          format.delete(entry)
          format << (range[0]..range[1])
        end
      end
      build_string(format)
    else
      default_format
    end
  end

  def build_string format
    has_header? ? CONFIG[@code]['header']+format.collect{|index| @extracted[index]}.join(' ')+"\n\n"
                : format.collect{|index| @extracted[index]}.join(' ')+"\n"
  end

  def default_format
    self.extracted.to_s+"\n"
    #self.extracted.join(' ')+"\n"
  end

  def has_format?
    CONFIG[@code] && CONFIG[@code]['format']
  end

  def has_header?
    CONFIG[@code] && CONFIG[@code]['header'] 
  end
end
