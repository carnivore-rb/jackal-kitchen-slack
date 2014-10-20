require 'jackal-kitchen-slack'

module Jackal
  # Formulate kitchen output into short message
  module KitchenSlack
    class Message < Jackal::Callback

      def setup(*_)
      end

      # Validity of message
      #
      # @param message [Carnivore::Message]
      # @return [Truthy, Falsey]
      def valid?(message)
        super do |payload|
          payload.get(:data, :kitchen)
        end
      end

      def execute(message)
        failure_wrap(message) do |payload|
          payload[:data][:slack] = Smash.new
          payload[:data][:slack][:messages] = [format_message(payload)]
          job_completed(:kitchen_messenger, payload, message)
        end
      end

      # payload:: Payload
      # Return formatted message hash: {:message => 'something happened', :color => 'good|blue|FFF000'}
      # depending on what's loaded in the environment
      def format_message(payload)
        ref = payload.get(:data, :github, :head_commit, :id)
        repo = payload.get(:data, :github, :repository, :full_name)
        success = !payload.fetch(:data, :kitchen, :result, {}).values.detect do |v|
          v.to_s == 'fail'
        end
        Smash.new(
          :message => payload.get(:data, :kitchen),
          :color => success ? config.fetch(:colors, :success, 'good') : config.fetch(:colors, :failure, 'danger')
        )
      end

      def format_link(uri,anchor)
        "<#{uri}|#{anchor}>"
      end

    end
  end
end
