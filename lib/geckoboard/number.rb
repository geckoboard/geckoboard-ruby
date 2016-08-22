module Geckoboard
  class Number < Field
    def to_hash
      super.merge(type: :number)
    end
  end
end
