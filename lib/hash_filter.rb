require 'hash_filter/operation'

# Easy hash filtering via simple operations
#
# @see README
class HashFilter
  # List of operations to be applied
  attr_reader :operations

  # List of elements to keep before applying operations
  attr_reader :keeps

  protected :operations, :keeps

  # Initialize a hash filter
  #
  # @yield [HashFilter] instance evals self if a block is provided
  #
  # @example
  #   filter = HashFilter.new do
  #     rename /(.*?)\.htm$/, '\1.html'
  #     delete /\.(jpg|gif)$/
  #   end
  #
  #   filter.delete /\.png$/
  #
  #   filter.apply(some_hash)
  def initialize(&block)
    @keeps      = []
    @operations = []
    instance_eval(&block) if block
  end

  # Rename a key
  #
  # @param from [Regexp, String] rename source
  # @param to [String] rename target
  #
  # @example
  #   HashFilter.new do
  #     rename /(.*?)\.htm$/, '\1.html'
  #   end
  def rename(from, to)
    operation Operation::Rename, from, to
  end

  # Delete a key
  #
  # @param key [Regexp, String] key to delete
  #
  # @example
  #   remove_images = HashFilter.new do
  #     delete /\.jpg$/
  #     delete /\.png$/
  #     delete /\.gif$/
  #   end
  def delete(key)
    operation Operation::Delete, key
  end

  # Combine other filters
  #
  # @param filter [HashFilter] other filter
  def inject(filter)
    @keeps.concat filter.keeps
    @operations.concat filter.operations
  end

  # Keep given key
  #
  # @param key [Regexp, String] key to keep
  #
  # @example
  #   # Delete everything but keep GIFs
  #   HashFilter.new do
  #     keep /\.gif$/
  #     delete /.*/
  #   end
  def keep(key)
    @keeps << key
  end

  # Apply this filter to hash
  #
  # @param hash [Hash] hash (hash-like) to filter
  def apply(hash)
    apply_operations(@operations, hash.dup)
  end

  # Add a custom operation
  #
  # @param class_name [Operation] operation class
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
  def operation(class_name, *args)
    @operations << class_name.new(*args)
  end

  private

  # Applies all operations to target hash
  #
  # @param operations [Array<Operation>] a list of operations
  # @param hash [Hash] target hash
  def apply_operations(operations, hash)
    hash.keys.each do |key|
      next if keep?(key)
      operations.each do |operation|
        apply_operation(operation, hash, key)
      end
    end
    hash
  end

  # Should the key be kept?
  #
  # @param key [Regexp, String, Object]
  def keep?(key)
    @keeps.any? { |keep| keep === key }
  end

  # Apply a single operation
  #
  # @see Operation#execute
  def apply_operation(operation, hash, key)
    if operation.matches?(key)
      operation.execute(hash, key)
    end
  end
end
