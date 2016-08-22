module Geckoboard
  class Date < Field
    def to_hash
      super.merge(type: :date)
    end
  end
end
