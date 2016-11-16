require "./utmpx/*"

module UTMPX

  class Reader
    def self.read(&blk)
      LibUTMPX.setutxent()

      while !(ptr = LibUTMPX.getutxent()).null?
        yield Entry.new(ptr.value)
      end

      LibUTMPX.endutxent()
    end
  end

  class Entry
    getter! :username, :pid, :device, :type, :host, :at

    def initialize(entry : LibUTMPX::UTMPX)
      self.username = entry.ut_user
      self.pid = entry.ut_pid
      self.device = entry.ut_line
      self.type = entry.ut_type
      self.host = entry.ut_host
      self.at = entry.ut_tv
    end

    def boot_time?
      self.type == LibUTMPX::BOOT_TIME
    end

    def dead_process?
      self.type == LibUTMPX::DEAD_PROCESS
    end

    def empty?
      self.type == LibUTMPX::EMPTY
    end

    def init_process?
      self.type == LibUTMPX::INIT_PROCESS
    end

    def login_process?
      self.type == LibUTMPX::LOGIN_PROCESS
    end

    def new_time?
      self.type == LibUTMPX::NEW_TIME
    end

    def old_time?
      self.type == LibUTMPX::OLD_TIME
    end

    def run_lvl?
      self.type == LibUTMPX::RUN_LVL
    end

    def user_process?
      self.type == LibUTMPX::USER_PROCESS
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
