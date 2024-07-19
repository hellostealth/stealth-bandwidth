# frozen_string_literal: true

# module Stealth
#   module Services
#     module Bandwidth
#       class MessageHandler < Stealth::Services::BaseMessageHandler
#         attr_reader :service_message, :params, :headers

#         def initialize(params:, headers:)
#           @params = params
#           @headers = headers
#         end

#         def coordinate
#           case params.dig('message', 'direction')
#           when "in"
#             Stealth::Services::HandleMessageJob.perform_async(
#               'bandwidth',
#               params,
#               headers
#             )
#           when "out"
#             # Ignoring outbound messages
#           end

#           # Relay our acceptance
#           [202, 'Accepted']
#         end

#         def process
#           @service_message = ServiceMessage.new(service: 'bandwidth')

#           service_message.sender_id = params.dig('message', 'from')
#           service_message.target_id = params.dig('message', 'to')
#           service_message.message = params.dig('message', 'text')
#           service_message.timestamp = params.dig('message', 'time')
#           params.dig('message', 'media')&.each do |attachment_url|
#             service_message.attachments << {
#               url: attachment_url
#             }
#           end

#           service_message
#         end

#       end

#     end
#   end
# end
