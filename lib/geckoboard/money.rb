module Geckoboard
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
end
