module Geckoboard
  class Field
    attr_reader :id, :name

    def initialize(id, name: nil)
      raise ArgumentError, "`id:' is a required argument" if id.nil?

      @id   = id
      @name = name
    end

    def to_hash
      { name: name }
    end
  end

  class OptionalField < Field
    attr_reader :optional

    def initialize(id, optional: false, **options)
      super(id, **options)

      @optional = optional
    end

    def to_hash
      super.merge(optional: @optional)
    end
  end

  class StringField < Field
    def to_hash
      super.merge(type: :string)
    end
  end

  class NumberField < OptionalField
    def to_hash
      super.merge(type: :number)
    end
  end

  class DateField < Field
    def to_hash
      super.merge(type: :date)
    end
  end

  class DateTimeField < Field
    def to_hash
      super.merge(type: :datetime)
    end
  end

  class MoneyField < OptionalField
    attr_reader :currency_code

    def initialize(id, currency_code: nil, **options)
      raise ArgumentError, "`currency_code:' is a required argument" if currency_code.nil?

      super(id, **options)
      @currency_code = currency_code
    end

    def to_hash
      super.merge(type: :money, currency_code: currency_code)
    end
  end

  class DurationField < OptionalField
    attr_reader :time_unit

    def initialize(id, time_unit: nil, **options)
      raise ArgumentError, "`time_unit:' is a required argument" if time_unit.nil?

      super(id, **options)
      @time_unit = time_unit
    end

    def to_hash
      super.merge(type: :duration, time_unit: time_unit)
    end
  end

  class PercentageField < OptionalField
    def to_hash
      super.merge(type: :percentage)
    end
  end
end