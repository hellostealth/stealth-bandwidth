module Stealth
  module Services
    module Bandwidth

      class CallEventHandler
        def self.determine_event_type(request)
          # Create a new instance of ServiceMessage with the request params and headers
          service_call = Stealth::Services::Bandwidth::ServiceCall.new(
            params: request.params,
            headers: request.headers
          ).process

          # Determine the event type and include the service_message in the response
          case service_call.service_event_type
          when 'initiate'
            { type: :call_received, service_call: service_call }
          else
            { type: :unknown_event }
          end
        end
      end

    end
  end
end
