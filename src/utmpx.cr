require "./utmpx/*"

module UTMPX

  class Reader
    def self.read(&blk)
      LibUTMPX.setutxent()

      while !(ptr = LibUTMPX.getutxent()).null?
        entry = Entry.new(ptr.value)
        yield entry
      end

      LibUTMPX.endutxent()
    end
  end

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
