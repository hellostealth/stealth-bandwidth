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
          Stealth::Services::HandleMessageJob.perform_async(
            'bandwidth',
            params,
            headers
          )

          # Relay our acceptance
          [202, 'Accepted']
        end

        def process
          @service_message = ServiceMessage.new(service: 'bandwidth')
          ### After V2
          # service_message.sender_id = params.dig('message', 'from')
          # service_message.target_id = Array(params.dig('message', 'to'))
          # service_message.message = params.dig('message', 'text')
          # service_message.timestamp = params.dig('message', 'time')
          service_message.sender_id = params.dig('from')
          service_message.target_id = Array(params.dig('to'))
          service_message.message = params.dig('text')
          service_message.timestamp = params.dig('time')

          params['media']&.each do |attachment_url|
            service_message.attachments << {
              url: attachment_url
            }
          end

          service_message
        end

      end

    end
  end
end
