module Geckoboard
  class String < Field
    def to_hash
      super.merge(type: :string)
    end
  end
end
