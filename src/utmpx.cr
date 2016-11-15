require "./utmpx/*"

module UTMPX
  LibUTMPX.setutxent()
  while !(ptr = LibUTMPX.getutxent()).null?
    t = ptr.value
    # if t.ut_type == LibUTMPX::USER_PROCESS
      e = Entry.new(t)
      puts e.at, e.type, e.username
    # end
  end
  LibUTMPX.endutxent()

  class Entry
    getter :username, :pid, :device, :type, :host, :at

    def initialize(entry : LibUTMPX::UTMPX)
      self.username = entry.ut_user
      self.pid = entry.ut_pid
      self.device = entry.ut_line
      self.type = entry.ut_type
      self.host = entry.ut_host
      self.at = entry.ut_tv
    end

    private def username=(value)
      user_len = LibC.strlen(value)
      @username = String.new(value.to_slice[0, user_len])
    end

    private def pid=(value)
      @pid = Int32.new(value)
    end

    private def device=(value)
      line_len = LibC.strlen(value)
      @device = String.new(value.to_slice[0, line_len])
    end

    private def type=(value)
      @type = Int32.new(value)
    end

    private def host=(value)
      host_len = LibC.strlen(value)
      @host = String.new(value.to_slice[0, host_len])
    end

    private def at=(value)
      @at = Time.epoch(value.tv_sec)
    end
  end
end
