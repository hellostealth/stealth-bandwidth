# frozen_string_literal: true

require 'http'

require 'stealth/services/bandwidth/message_handler'
require 'stealth/services/bandwidth/reply_handler'
require 'stealth/services/bandwidth/setup'

module Stealth
  module Services
    module Bandwidth
      class Client < Stealth::Services::BaseClient

        attr_reader :http_client, :reply, :endpoint

        def initialize(reply:)
          @reply = reply
          user_id = Stealth.config.bandwidth.user_id
          token = Stealth.config.bandwidth.api_token
          secret = Stealth.config.bandwidth.api_secret
          # @endpoint = "https://messaging.bandwidth.com/api/v2/users/#{user_id}/messages"
          @endpoint = "https://api.catapult.inetwork.com/v2/users/#{user_id}/messages"
          @http_client = HTTP
                          .timeout(connect: 15, read: 30)
                          .basic_auth(user: token, pass: secret)
                          .headers('Content-Type' => 'application/json')
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
