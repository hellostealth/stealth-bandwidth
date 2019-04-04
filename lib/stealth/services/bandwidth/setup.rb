# frozen_string_literal: true

require 'stealth/services/bandwidth/client'

module Stealth
  module Services
    module Bandwidth

      class Setup

        class << self
          def trigger
            Stealth::Logger.l(
              topic: "bandwidth",
              message: "There is no setup needed!"
            )
          end
        end

      end

    end
  end
end
