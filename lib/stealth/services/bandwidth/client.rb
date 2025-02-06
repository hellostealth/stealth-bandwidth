# frozen_string_literal: true

require 'http'

# require 'stealth/services/bandwidth/message_handler'
require 'stealth/services/bandwidth/setup'
require 'stealth/services/bandwidth/event_handler'
require 'stealth/services/bandwidth/reply_handler'

module Stealth
  module Services
    module Bandwidth
      class Client < Stealth::Services::BaseClient

        attr_reader :http_client, :reply, :endpoint

        def initialize(reply:, **args)
          @reply = reply
          account_id = Stealth.config.dig('bandwidth', 'account_id')
          username = Stealth.config.dig('bandwidth', 'api_username')
          password = Stealth.config.dig('bandwidth', 'api_password')

          @endpoint = "https://messaging.bandwidth.com/api/v2/users/#{account_id}/messages"
          @http_client = HTTP
                          .timeout(connect: 15, read: 30)
                          .basic_auth(user: username, pass: password)
                          .headers('Content-Type' => 'application/json; charset=utf-8')
        end

        def transmit
          # Don't transmit anything for delays
          return true if reply.blank?
          json_reply = Oj.dump(reply, mode: :compat)
          response = http_client.post(endpoint, body: json_reply)

          Stealth::Logger.l(
            topic: 'bandwidth',
            message: "Transmitting. Response: #{response.status.code}: #{response.body}"
          )
        end

      end
    end
  end
end
