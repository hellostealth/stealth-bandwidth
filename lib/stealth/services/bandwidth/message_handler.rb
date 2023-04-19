# frozen_string_literal: true

module Stealth
  module Services
    module Bandwidth
      class MessageHandler < Stealth::Services::BaseMessageHandler
        attr_reader :service_message, :params, :headers

        def initialize(params:, headers:)
          @params = params
          @headers = headers
        end

        def coordinate
          inbound_message = params.dig('message', 'direction') == "in"
          inbound_call = params[:eventType] == "initiate"
          outbound_message = params.dig('message', 'direction') == "out"


          if inbound_message || inbound_call
            Stealth::Services::HandleMessageJob.perform_async(
              'bandwidth',
              params,
              headers
            )
          elsif outbound_message
            # Ignoring outbound messages
          end

          # Relay our acceptance
          [202, 'Accepted']
        end

        def process
          @service_message = BandwidthServiceMessage.new(service: 'bandwidth')

          # message-related params
          service_message.sender_id = params.dig('message', 'from')
          service_message.target_id = params.dig('message', 'to')
          service_message.message = params.dig('message', 'text')
          service_message.timestamp = params.dig('message', 'time')
          params.dig('message', 'media')&.each do |attachment_url|
            service_message.attachments << {
              url: attachment_url
            }
          end

          # call-related params
          service_message.call_id = params["callId"]
          service_message.call_url = params["callUrl"]
          service_message.call_direction = params["direction"]
          service_message.caller_number = params["from"]
          service_message.callee_number = params["to"]
          service_message.call_initiated_at = params["startTime"]

          service_message
        end

      end

    end
  end
end
