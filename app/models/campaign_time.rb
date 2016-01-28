class CampaignTime

attr_accessor :start_hour, :start_min, :start_second, :start_frames, :hours, :minutes,  :seconds, :frames,  :end_hour, :end_min, :end_second, :end_frames


def hour_min_sec_ff(s_hr, s_min, s_sec, s_ff, duration_seconds, duration_ff)

    total_ff = (s_ff + duration_ff) % 24
    if (s_ff + duration_ff) / 24 != 23
      self.end_frames = (s_ff + duration_ff) / 24
    else
      total_ff += 1
      self.end_frames = 0
    end

    first = (s_hr.to_i * 60 * 60) + (s_min.to_i * 60) + s_sec.to_i + total_ff.to_i

    totalseconds = duration_seconds.to_i + first
    self.end_second    =  totalseconds % 60
    totalseconds = (totalseconds - @end_sec) / 60
    self.end_min    =  totalseconds % 60
    totalseconds = (totalseconds - @end_min) / 60
    self.end_hour      =  totalseconds % 24
end

end
