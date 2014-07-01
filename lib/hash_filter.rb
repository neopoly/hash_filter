class HashFilter
  attr_reader :operations
  protected :operations

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
    @operations.concat filter.operations
  end

  def keep(key)
    @keeps << key
  end

  def apply(hash)
    dup = hash.dup
    dup.keys.each do |key|
      next if keep?(key)
      @operations.each do |operation|
        if operation.matches?(key)
          operation.execute(dup, key)
        end
      end
    end
    dup
  end

  def operation(class_name, *args)
    @operations << class_name.new(*args)
  end

  private

  def keep?(key)
    @keeps.any? do |keep|
      keep === key
    end
  end

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

    class Delete < self
      def execute(hash, key)
        hash.delete(key)
      end
    end
  end
end
