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
        client = @server.accept
        Thread.start(client.read) do |s|
          error = s
          case error
            when /^\[NOTICE\]/
              error = notice(error)
            when /^\[WARNING\]/
              error = warning(error)
            when /^\[CRITICAL\]/
              error = critical(error)
            else
              s.close
          end
          print(error, "\n")
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

  def alert(alert_string)
    return "Alert received"
  end

  def warning(warning_string)
    return "Warning received"
  end

  def critical(critical_string)
    return "Critical received"
  end

  def update_config
    File.open(@configfile,'w') { |f| f.puts @config.to_yaml }
  end
end