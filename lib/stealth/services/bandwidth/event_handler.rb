module Stealth
  module Services
    module Bandwidth

      class EventHandler
        def self.determine_event_type(request)
          # WIP will handle calls and other events here
          case request.params.dig(:_json)&.first&.dig(:type)
          when 'message-received'
            :text_message_receive
          # when 'unsubscribe'
          #   :unsubscribe
          else
            :unknown_event
          end
        end
      end

    end
  end
end
