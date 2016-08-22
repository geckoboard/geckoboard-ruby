module Geckoboard
  class Field
    attr_reader :id, :name

    def initialize(id, name: nil)
      raise ArgumentError, "`name:' is a required argument" if name.nil?

      @id   = id
      @name = name
    end

    def to_hash
      { name: name }
    end
  end

  class String < Field
    def to_hash
      super.merge(type: :string)
    end
  end

  class Number < Field
    def to_hash
      super.merge(type: :number)
    end
  end

  class Date < Field
    def to_hash
      super.merge(type: :date)
    end
  end

  class DateTime < Field
    def to_hash
      super.merge(type: :datetime)
    end
  end

  class Money < Field
    attr_reader :currency

    def initialize(id, name: nil, currency: nil)
      raise ArgumentError, "`currency:' is a required argument" if currency.nil?

      super(id, name: name)
      @currency = currency
    end

    def to_hash
      super.merge(type: :money, currency: currency)
    end
  end

  class Percentage < Field
    def to_hash
      super.merge(type: :percentage)
    end
  end
end
