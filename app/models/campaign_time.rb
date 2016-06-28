class CampaignTime
# :hours, :minutes,
attr_accessor :start_hour, :start_min, :start_second, :start_frames, :seconds, :frames,  :end_hour, :end_min, :end_second, :end_frames, :day, :cost_per_sec


  def add_sec_fr

    #(s_hr, s_min, s_sec, s_ff, duration_seconds, duration_ff)
     extra_secs = 0
     totalseconds = 0
     self.frames = 0 if self.frames.blank?
     self.start_frames = 0 if self.start_frames.blank?
     self.end_hour, self.end_min, self.end_second, self.end_frames, self.day = 0,0,0,0,0

      self.end_frames = (self.start_frames.to_i + self.frames.to_i) % 24
      if (self.start_frames.to_i + self.frames.to_i) > 23
       extra_secs = 1
      end

      first = (self.start_hour.to_i * 60 * 60) + (self.start_min.to_i * 60) + self.start_second.to_i
      duration_seconds =   self.seconds.to_i + extra_secs.to_i

      totalseconds = duration_seconds + first
      self.end_second    =  totalseconds % 60
      totalseconds = (totalseconds - self.end_second) / 60
      self.end_min    =  totalseconds % 60
      totalseconds = (totalseconds - self.end_min) / 60
      self.end_hour =  totalseconds % 24
      if (totalseconds % 24) >= 24
        self.day = 1
      end
  end

  

end
