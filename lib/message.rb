class Message
  attr_reader :extracted, :format
  CONFIG = YAML.load_file("messages.yaml")

  def initialize line
    @extracted = line.split(' ')
    @from   = @extracted[0]
    @code   = CONFIG.has_key?(@from) ? @from : @extracted[1]
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
    if has_template?
      template = CONFIG[@code]['template']
      format.each do |entry|
        content = @extracted[entry]
        content = content.join(' ') if content.class == Array
        template.gsub!(/entry#{format.find_index(entry)}/,content)
      end
      template
    else
      format.collect{|index| @extracted[index]}.join(' ')+"\n"
    end
  end

  def default_format
    self.extracted.to_s+"\n"
    #self.extracted.join(' ')+"\n"
  end

  def has_template?
    CONFIG[@code] && CONFIG[@code]['template']
  end

  def has_format?
    CONFIG[@code] && CONFIG[@code]['format']
  end

  def has_header?
    CONFIG[@code] && CONFIG[@code]['header']
  end
end
