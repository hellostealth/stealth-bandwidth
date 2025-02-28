module Stealth
  module Services
    module Bandwidth

      class EventHandler < Stealth::ServiceEvent
        attr_reader :params, :headers
        attr_accessor :sender_id, :target_id, :message, :timestamp, :event_type, :event, :attachments, :selected_option, :previous_message, :nlp_result

        def initialize(params:, headers:)
          super(service: 'bandwidth')
          @params = parse(params)
          @headers = headers
          @attachments = []
        end

        def coordinate
          return [202, 'Accepted'] if should_ignore_event?(params)
          Stealth::Services::HandleEventJob.perform_async('bandwidth', params, headers)
          [202, 'Accepted']
        end


        def process
          self.sender_id = params.dig('message', 'from')
          self.target_id = params.dig('message', 'to').first
          self.message = params.dig('message', 'text')
          self.timestamp = params.dig('message', 'time')
          params.dig('message', 'media')&.each do |attachment_url|
            self.attachments << {
              url: attachment_url
            }
          end

          mapped_event = map_event_type
          self.event_type = mapped_event[:event_type]
          self.event = mapped_event[:event]

          self
        end

        private

        def should_ignore_event?(params)
          event = params.dig('type')

          ignored_events = [
            event["message-sending"].present?,
            event["message-delivered"].present?
          ]

          ignored_events.any?
        end

        def parse(params)
          return params["_json"] if params["_json"].present?
          params
        end

        def map_event_type
          event_type = params.dig('type')

          event_mapping = {
            'message-received' => 'text_received'
          }

          Stealth::EventMapping.map_event(service: 'bandwidth', event_type: event_mapping[event_type])
        end
      end

    end
  end
end
