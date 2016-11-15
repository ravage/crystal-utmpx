require "./utmpx/*"

module Utmpx
  LibUTMPX.setutxent()
  while !(ptr = LibUTMPX.getutxent()).null?
    t = ptr.value
    if t.ut_type == LibUTMPX::USER_PROCESS
      puts String.new(t.ut_user.to_slice)
      puts t.ut_id
      puts String.new(t.ut_line.to_slice)
      puts t.ut_type
      puts String.new(t.ut_host.to_slice)
      puts Time.epoch(t.ut_tv.tv_sec)
    end
  end
  LibUTMPX.endutxent()
end
