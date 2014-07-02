class HashFilter
  class Operation
    class Delete < self
      def execute(hash, key)
        hash.delete(key)
      end
    end
  end
end
