class HashFilter
  class Operation
    # Delete a key from hash
    class Delete < self
      def execute(hash, key)
        hash.delete(key)
      end
    end
  end
end
