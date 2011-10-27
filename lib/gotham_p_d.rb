class GothamPD
  require 'socket'
  require 'plugins/internal/system_security'
  include Batman
  include ClientConnect
  include SystemSecurity

  attr_accessor :config
  attr_reader :configfile, :commissioner

#  def uid0_check
#    passwd_file = File.open("/etc/passwd").readlines
#    passwd_file.each do |line|
#      line_array = line.split(":")
#      next if line_array[0] == 'root'
#      if line_array[2] == '0'
#        alert('c', "Non-root UID 0 account detected: #{line_array[0]}", @commissioner)
#      end
#    end
#  end
end
