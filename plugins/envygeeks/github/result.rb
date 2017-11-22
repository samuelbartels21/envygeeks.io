# Frozen-String-Literal: true
# Copyright 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

module EnvyGeeks
  class Github
    class Result
      extend  Forwardable::Extended
      include Enumerable

      rb_delegate :keys,     to: :@data
      rb_delegate :each,     to: :@data
      rb_delegate :merge,    to: :@data
      rb_delegate :has_key?, to: :@data
      rb_delegate :to_enum,  to: :@data
      rb_delegate :values,   to: :@data
      rb_delegate :merge!,   to: :@data
      rb_delegate :to_h,     to: :@data

      # --
      def initialize(data = {})
        @data = data
        setup
      end

      # --
      # @return [self.class,<Any>] the result
      # Wraps around fetch so that we set the result to
      #   the proper type when we have it.
      # --
      def fetch(k, &block)
        wrap(@data.fetch(k, &block))
      end

      # --
      # @note This freezes the class and the hash.
      # Wraps around class freeze and hash freeze.  This is
      #   done this way because shipping a delegation straight
      #   to hash will return the raw hash, not he class.
      # @return [self] the frozen result.
      # --
      def freeze
        @data.freeze
        super
      end

      # --
      # @return [true,false] whether both are frozen.
      # Lets you know if the hash, and the class are frozen.
      # @note you should @see #freeze
      # --
      def frozen?
        @data.frozen? && \
          super
      end

      # --
      # @return the value given.
      # Simply just wraps around the setter, making sure
      #   that if you set a value, it's a hash if it's currently
      #   a `self.class` this way we don't duplicate effort.
      # --
      def []=(k, v)
        v = v.to_h if v.is_a?(self.class)
        @data[k] = v
      end

      # --
      # @return nil
      # Sets up the methods so that method missing doesn't
      #   have to always be called.
      # --
      private
      def setup
        @data.each_key do |k|
          u = ActiveSupport::Inflector.underscore(k)

          [k, u].each do |m|
            self.class.send(:define_method, m) do
              wrap(self[k])
            end
          end
        end
      end

      # --
      # @return [self.class, <Any>] the result.
      # Takes in the result and then determines if it needs
      #   to be wrapped in this class, hashes are looped and
      #   wrapped and hashes are simply just wrapped.
      # rubocop:disable Metrics/PerceivedComplexity
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Lint/LiteralAsCondition
      # --
      private
      def wrap(val)
        val = val[:edges] if val.is_a?(Hash) && val.keys == [:edges]
        val = val[:nodes] if val.is_a?(Hash) && val.keys == [:nodes]
        val = val[:node]  if val.is_a?(Hash) && val.keys == [:node]

        case true
        when val.is_a?(Hash)  then self.class.new(val)
        when val.is_a?(Array) then val.map do |v|
          wrap(v)
        end
        else
          val
        end
      end

      alias [] fetch
    end
  end
end
