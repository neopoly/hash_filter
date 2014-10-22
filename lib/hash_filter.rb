require 'hash_filter/operation'

class HashFilter
  attr_reader :operations, :keeps
  protected :operations, :keeps

  def initialize(&block)
    @keeps      = []
    @operations = []
    instance_eval(&block) if block
  end

  def rename(from, to)
    operation Operation::Rename, from, to
  end

  def delete(key)
    operation Operation::Delete, key
  end

  def inject(filter)
    @keeps.concat filter.keeps
    @operations.concat filter.operations
  end

  def keep(key)
    @keeps << key
  end

  def apply(hash)
    apply_operations(@operations, hash.dup)
  end

  def operation(class_name, *args)
    @operations << class_name.new(*args)
  end

  private

  def apply_operations(operations, hash)
    hash.keys.each do |key|
      next if keep?(key)
      operations.each do |operation|
        apply_operation(operation, hash, key)
      end
    end
    hash
  end

  def keep?(key)
    @keeps.any? { |keep| keep === key }
  end

  def apply_operation(operation, hash, key)
    if operation.matches?(key)
      operation.execute(hash, key)
    end
  end
end
