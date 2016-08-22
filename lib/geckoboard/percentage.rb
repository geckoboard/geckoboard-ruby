module Geckoboard
  class Percentage < Field
    def to_hash
      super.merge(type: :percentage)
    end
  end
end
