# coding: utf-8
# frozen_string_literal: true

module Stealth
  module Services
    module Bandwidth
      class ReplyHandler < Stealth::Services::BaseReplyHandler

        attr_reader :recipient_id, :reply

        def initialize(recipient_id: nil, reply: nil)
          @recipient_id = recipient_id
          @reply = reply
        end

        def text
          check_text_length

          translated_reply = reply['text']

          suggestions = generate_suggestions(suggestions: reply['suggestions'])
          buttons = generate_buttons(buttons: reply['buttons'])

          if suggestions.present?
            translated_reply = [
              translated_reply,
              'Reply with one of the following:'
            ].join("\n")

            puts "Translated reply after first pass: #{translated_reply}"

            suggestions.each_with_index do |suggestion, i|
              translated_reply = [
                translated_reply,
                "\"#{i}\" for #{suggestion}"
              ].join("\n")
            end

            puts "Translated reply after second pass: #{translated_reply}"
          end

          if buttons.present?

          end

          format_response({ text: translated_reply })
        end

        def image
          check_text_length

          format_response({ text: reply['text'], media_url: reply['image_url'] })
        end

        def audio
          check_text_length

          format_response({ text: reply['text'], media_url: reply['audio_url'] })
        end

        def video
          check_text_length

          format_response({ text: reply['text'], media_url: reply['video_url'] })
        end

        def file
          check_text_length

          format_response({ text: reply['text'], media_url: reply['file_url'] })
        end

        def delay

        end

        private

          def check_text_length
            if reply['text'].present? && reply['text'].size > 2048
              raise(ArgumentError, 'Text messages must be 2048 characters or less.')
            end
          end

          def format_response(response)
            sender_info = {
              from: Stealth.config.bandwidth.from_phone.to_s,
              to: recipient_id
            }
            response.merge(sender_info)
          end

          def generate_suggestions(suggestions:)
            return if suggestions.blank?

            mf = suggestions.collect do |suggestion|
              suggestion['text']
            end.compact
          end

          def generate_buttons(buttons:)
            return if buttons.blank?

            buttons.map do |button|
              case button['type']
              when 'url'
                { button['text'] => button['url'] }
              when 'payload'
                button_value = "Text #{button['payload'].upcase}"
                { button['text'] => button_value }
              when 'call'
                { button['text'] => button['phone_number'] }
              else # Don't raise for unsupported buttons
                next
              end
            end.compact
          end

      end
    end
  end
end
