require "react_on_rails/utils"

module ReactOnRails
  module ReactComponent
    class Options
      include Utils::Required

      NO_PROPS = {}.freeze
      HIDDEN = "display:none".freeze

      def initialize(name: required("name"), options: required("options"))
        @name = name
        @options = options
      end

      def props
        options.fetch(:props) { NO_PROPS }
      end

      def name
        @name.camelize
      end

      def dom_id
        @dom_id ||= options.fetch(:id) { generate_unique_dom_id }
      end

      def html_options
        options[:html_options].to_h
      end

      def prerender
        retrieve_key(:prerender)
      end

      def trace
        retrieve_key(:trace)
      end

      def replay_console
        retrieve_key(:replay_console)
      end

      def raise_on_prerender_error
        retrieve_key(:raise_on_prerender_error)
      end

      def data
        {
          component_name: name,
          props: props,
          trace: trace,
          dom_id: dom_id
        }
      end

      def style
        return nil if ReactOnRails.configuration.skip_display_none
        HIDDEN
      end
      
      def tag
        options.fetch(:tag) { :div }
      end

      private

      attr_reader :options

      def generate_unique_dom_id
        "#{@name}-react-component-#{SecureRandom.uuid}"
      end

      def retrieve_key(key)
        options.fetch(key) do
          ReactOnRails.configuration.public_send(key)
        end
      end
    end
  end
end
