lib LibUTMPX

  UTX_IDSIZE = 4
  UTX_HOSTSIZE = 256
  UTX_LINESIZE = 32

  EMPTY = 0
  RUN_LVL = 1
  BOOT_TIME = 2
  OLD_TIME = 3
  NEW_TIME = 4
  INIT_PROCESS = 5
  LOGIN_PROCESS = 6
  USER_PROCESS = 7
  DEAD_PROCESS = 8

  {% if flag?(:x86_64) %}
    alias SizeT = Int64
  {% else %}
    alias SizeT = Int32
  {% end %}

  {% if flag?(:darwin) %}
    UTX_USERSIZE = 256
  {% elsif flag?(:linux) %}
    UTX_USERSIZE = 32
  {% end %}

  struct ExitStatus
    e_termination : LibC::Short
    e_exit : LibC::Short
  end

  struct UTMPX_DARWIN
    ut_user : StaticArray(LibC::Char, UTX_USERSIZE) # User login name
    ut_id : StaticArray(LibC::Char, UTX_IDSIZE) # Record identifier
    ut_line : StaticArray(LibC::Char, UTX_LINESIZE) # Device name
    ut_pid : LibC::PidT # Process ID
    ut_type : LibC::Short # Type of entry
    ut_tv : LibC::Timeval # Time entry was made
    ut_host : StaticArray(LibC::Char, UTX_HOSTSIZE) # Remote hostname
    ut_pad: UInt32
  end

  struct UTMPX_LINUX
    ut_type : LibC::Short # Type of entry
    ut_pid : LibC::PidT # Process ID
    ut_line : StaticArray(LibC::Char, UTX_LINESIZE) # Device name
    ut_id : StaticArray(LibC::Char, UTX_IDSIZE) # Record identifier
    ut_user : StaticArray(LibC::Char, UTX_USERSIZE) # User login name
    ut_host : StaticArray(LibC::Char, UTX_HOSTSIZE) # Remote hostname
    ut_exit : ExitStatus
    ut_session : SizeT
    ut_tv : LibC::Timeval # Time entry was made
    __unused : StaticArray(LibC::Char, 20)
  end

  {% if flag?(:darwin) %}
    alias UTMPX = UTMPX_DARWIN
  {% elsif flag?(:linux) %}
    alias UTMPX = UTMPX_LINUX
  {% end %}


  fun getutxent() : UTMPX*
  fun setutxent()
  fun endutxent()
end
