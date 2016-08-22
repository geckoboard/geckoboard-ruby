module Geckoboard
  class DateTime < Field
    def to_hash
      super.merge(type: :datetime)
    end
  end
end
