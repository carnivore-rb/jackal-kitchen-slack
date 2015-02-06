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
        success = payload.get(:data, :kitchen, :judge, :decision)

        kitchen_message = []

        if success
          kitchen_message << "Good news, all tests passed for #{repo}"
        else
          kitchen_message << "Sorry, there were some test failures for #{repo}"
          failure_reasons = payload.get(:data, :kitchen, :judge, :reasons)
          failure_reasons.each do |reason|
            kitchen_message << "#{reason} failed"
          end
        end

        Smash.new(
          :message => kitchen_message.join("\n"),
          :color => success ? config.fetch(:colors, :success, 'good') : config.fetch(:colors, :failure, 'danger'),
          :judgement => {:success => success}
        )
      end

      def format_link(uri,anchor)
        "<#{uri}|#{anchor}>"
      end

    end
  end
end
