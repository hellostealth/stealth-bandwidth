module Stealth
  module Services
    module Bandwidth

      class ServiceCall < Stealth::ServiceCall
        attr_reader :params, :headers

        def initialize(params:, headers:)
          super(service: 'bandwidth')
          @params = params
          @headers = headers
        end

        def process
          self.call_id = params['callId']
          self.call_url = params['callUrl']
          self.sender_id = params['from']
          self.target_id = params['to']
          self.service_event_type = params['eventType']

          self
        end
      end

    end
  end
end
