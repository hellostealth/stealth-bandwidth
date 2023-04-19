module Stealth
  module Services
    module Bandwidth
      class BandwidthServiceMessage < Stealth::ServiceMessage
        attr_accessor :call_id,
                      :call_url,
                      :call_direction,
                      :caller_number,
                      :callee_number,
                      :call_initiated_at

      end
    end
  end
end
