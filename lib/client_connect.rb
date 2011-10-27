module ClientConnect
  def initialize
    require 'yaml'
    @configfile = "config/commissioner.yml"
    @config = YAML.load_file(@configfile)
    case @config["socket_type"]
      when "unix":
        @commissioner = UNIXSocket.new(@config["socket_path"])
      when "tcp":
        @commissioner = TCPSocket.new(@config["socket_ip"], @config["socket_port"])
      else
        raise ArgumentError, "Invalid Socket Type"
    end
  end
end