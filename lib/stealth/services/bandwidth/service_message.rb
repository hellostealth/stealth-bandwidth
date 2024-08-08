module Stealth
  module Services
    module Bandwidth

      class ServiceMessage < Stealth::ServiceMessage
        attr_reader :params, :headers

        def initialize(params:, headers:)
          super(service: 'bandwidth')
          @params = params
          @headers = headers
        end

        def process
          self.sender_id = params.dig('message', 'from')
          self.target_id = params.dig('to')
          self.message = params.dig('message', 'text')
          self.event_type = params.dig('type')
          self.timestamp = params.dig('time')

          # Handle attachments if any
          params.dig('message', 'media')&.each do |attachment_url|
            service_message.attachments << {
              url: attachment_url
            }
          end

          self
        end
      end

    end
  end
end
