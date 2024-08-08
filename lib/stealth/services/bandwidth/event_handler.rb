module Stealth
  module Services
    module Bandwidth

      class EventHandler
        def self.determine_event_type(request)
          # Create a new instance of ServiceMessage with the request params and headers
          service_message = Stealth::Services::Bandwidth::ServiceMessage.new(
            params: request.params.dig(:_json)&.first,
            headers: request.headers
          ).process

          # Determine the event type and include the service_message in the response
          case service_message.event_type
          when 'message-received'
            { type: :text_message_receive, service_message: service_message }
          else
            { type: :unknown_event }
          end
        end
      end

    end
  end
end
