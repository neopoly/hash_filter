class HashFilter
  # An abstract operation on a hash during the filter process
  #
  # @example
  #   class SwapKeyValue < HashFilter::Operation
  #     def execute(hash, key)
  #       value = hash.delete(key)
  #       hash[value] = key
  #     end
  #   end
  #
  #   HashFilter.new do
  #     operation SwapKeyValue
  #   end
  class Operation
    # A new operation
    #
    # @param key [String, Regexp, Object]
    def initialize(key)
      @key = key
    end

    # Execute the defined operation
    #
    # @param hash [Hash] target hash
    # @param key [String] key
    #
    # @see matches?
    def execute(hash, key)
      raise NotImplementedError
    end

    # Should this operation be executed?
    #
    # @param key [Regexp, String, Object] key
    def matches?(key)
      @key === key
    end
  end
end

require 'hash_filter/operation/delete'
require 'hash_filter/operation/rename'
