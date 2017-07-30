# Frozen-String-Literal: true
# Copyright 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

module EnvyGeeks
  module Drops

    # --
    # Encapsulates any hash and makes it easy to use without
    #   having to do any crazy nonsense like stringify key in
    #   a recursive way, and otherwise.
    # --
    class HashOrArray < Liquid::Drop
      extend Forwardable::Extended

      # --
      # @return [<HashOrArray>] the instance
      # There is no need for explaining it.
      # --
      def initialize(data)
        @data = data
      end

      # --
      # @return [<Any>] the value or nil.
      # Standard hash method so that you can also access
      #   the data like a hash/array.
      # --
      def [](key)
        liquid_method_missing(key)
      end

      # --
      # Uses Liquids method missing method to get the key
      #   when you try and access the drop like a chained method
      #   we do the case because oen day we might split out the
      #   class and it would require minimal refactor.
      # @return [<Any>] the value or nil.
      # --
      def liquid_method_missing(key)
        val = @data.fetch(key.to_s, @data[key.to_sym])

        case true
        when val.is_a?(Array) then HashOrArray.new(val)
        when val.is_a?( Hash) then HashOrArray.new(val)
        else
          val
        end
      end

      # --
      # Delegate methods directly to the hash or the Array,
      #   we don't need to carry these, enumerable does.
      # --

      delegate :last,             to: :@data
      delegate :each,             to: :@data
      delegate :first,            to: :@data
      delegate :each_with_index,  to: :@data
      delegate :to_enum,          to: :@data
      delegate :fetch,            to: :@data
      delegate :to_h,             to: :@data
      delegate :to_a,             to: :@data
      delegate :map,              to: :@data
    end
  end
end
