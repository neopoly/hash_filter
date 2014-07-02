class HashFilter
  class Operation
    def initialize(key)
      @key = key
    end

    def execute(hash, key)
      raise NotImplementedError
    end

    def matches?(key)
      @key === key
    end
  end
end

require 'hash_filter/operation/delete'
require 'hash_filter/operation/rename'
