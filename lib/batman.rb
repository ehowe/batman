$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Batman
  VERSION = '0.0.1'

  def alert(alert_level, message, commissioner)
    require 'socket'
    case alert_level
      when "n"
        alert_string = "[NOTICE] " + message
      when "w"
        alert_string = "[WARNING] " + message
      when "c"
        alert_string = "[CRITICAL] " + message
      else
        raise ArgumentError, "Invalid alert level"
    end

    puts alert_string
    commissioner.write(alert_string)
  end
end