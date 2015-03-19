class HashFilter
  class Operation
    # Rename a key in a hash
    class Rename < self
      def initialize(from, to)
        super(from)
        @to = to
      end

      def execute(hash, old)
        new = old.gsub(@key, @to)
        hash[new] = hash.delete(old)
      end
    end
  end
end
