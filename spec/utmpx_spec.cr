require "./spec_helper"

describe UTMPX do
  it "iterates over entries" do
    index = 0
    UTMPX::Reader.read do |entry|
      index += 1
    end

    index.should be > 1
  end

  it "hydrates entry object" do
    UTMPX::Reader.read do |entry|
      if entry.user_process?
        entry.username.size.should be > 0
        entry.pid.should be > 0
        entry.device.size.should be > 0
        (entry.host.size >= 0).should be_true
        entry.at.should be > Time.new(1970, 1, 1)
      end
    end
  end
end
