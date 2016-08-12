module Geckoboard
  class PayloadFormatter
    attr_reader :dataset

    def initialize(dataset)
      @dataset = dataset
    end

    def format(payload)
      payload.map do |item|
        item.inject({}) do |hash, (field_name, value)|
          field_name = field_name.to_s

          value = case field_type(field_name)
                  when 'date'     then format_date(value)
                  when 'datetime' then format_datetime(value)
                  else
                    value
                  end

          hash.merge(field_name => value)
        end
      end
    end

    private

    def field_type(name)
      @field_types ||= dataset.fields.inject({}) do |hash, (field_name, definition)|
        hash.merge(field_name => definition.fetch('type'))
      end

      @field_types.fetch(name, 'string')
    end

    def format_date(value)
      return value unless value.respond_to? :strftime
      value.strftime('%Y-%m-%d')
    end

    def format_datetime(value)
      return value unless value.respond_to? :strftime
      value.strftime('%Y-%m-%dT%H:%M:%S%:z')
    end
  end
end
