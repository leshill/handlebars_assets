module HandlebarsAssets
  module Server
    # Provides the requisite #to_{format} methods a Responder needs
    # to handle <code>respond_with</code>
    class Responder < ActionController::Responder
      # Ask the resource to give a HandleBars-compatible
      # representation and then passes it back to
      # <code>render</code> with the appropriate new options.
      #
      # Add the HBS-compatible version of the resource
      # to the locals hash, and ensure [:js, :jst] is in
      # the list of requested formats.
      def to_handlebars
        display resource, resource_options if resourceful?
      end
      alias_method :to_hbs, :to_handlebars

      private

      # Aggregate the options for displaying this resource
      # and return the new Hash.
      def resource_options
        { locals: resource_locals, formats: resource_formats }
      end

      # Merge any user-supplied locals with the formatted resource
      # and return the Hash
      def resource_locals
        (options.delete(:locals) || {}).merge!(resource.send(:"to_#{format}"))
      end

      # Merge any user-supplied formats with our
      # supported format(s) and return the new Array.
      def resource_formats
        supported_formats | (options.delete(:formats) || [])
      end

      # :nodoc:
      def supported_formats
        [:js, :jst]
      end
    end
  end
end
