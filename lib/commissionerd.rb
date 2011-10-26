class Commissionerd
  require 'socket'
  attr_reader :server, :configfile
  attr_accessor :config
  def initialize
    require 'yaml'
    @configfile = "config/commissionerd.yml"
    @config = YAML.load_file(@configfile)
    if @config["socket"] && ! @config["tcpip"]
      @server = UNIXServer.new(@config["socketfile"])
    elsif @config["tcpip"] && ! @config["socket"]
      @server = TCPServer.new(@config["ip"], @config["port"])
    elsif @config["tcpip"] && @config["socket"]
      raise ArgumentError, "Both tcpip and socket cannot be true"
    else
      raise ArgumentError, "Either tcpip or socket must be true"
    end
  end

  def server_loop
    loop do
      begin
        Thread.start(@server.accept) do |s|
          print(s, " is accepted\n")
          s.write(Time.now)
          print(s," is gone\n")
          s.close
        end
      rescue SystemExit, Interrupt, IRB::Abort
        if @config["socket"]
          File.unlink(@config["socketfile"])
        end
        exit!
      end
    end
  end

  def update_config
    File.open(@configfile,'w') { |f| f.puts @config.to_yaml }
  end
end