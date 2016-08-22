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
end
