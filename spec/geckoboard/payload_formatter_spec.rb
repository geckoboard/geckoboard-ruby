require 'spec_helper'

module Geckoboard
  describe PayloadFormatter do
    specify 'formats date fields' do
      dataset = build_dataset({
        'birthday' => { 'type' => 'date' }
      })

      formatter = PayloadFormatter.new(dataset)

      payload = formatter.format([
        { 'birthday' => Date.new(2016, 1, 1) },
        { 'birthday' => DateTime.new(2016, 1, 2, 10, 30) },
        { :birthday  => '2016-01-03' }
      ])

      expect(payload).to eq([
        { 'birthday' => '2016-01-01' },
        { 'birthday' => '2016-01-02' },
        { 'birthday' => '2016-01-03' }
      ])
    end

    specify 'formats datetime fields' do
      dataset = build_dataset({
        'moment_of_birth' => { 'type' => 'datetime' }
      })

      formatter = PayloadFormatter.new(dataset)

      payload = formatter.format([
        { 'moment_of_birth' => Date.new(2016, 1, 1) },
        { 'moment_of_birth' => DateTime.new(2016, 1, 2, 10, 30, 15) },
        { :moment_of_birth  => '2016-01-03T00:00:00+00:00' }
      ])

      expect(payload).to eq([
        { 'moment_of_birth' => '2016-01-01T00:00:00+00:00' },
        { 'moment_of_birth' => '2016-01-02T10:30:15+00:00' },
        { 'moment_of_birth' => '2016-01-03T00:00:00+00:00' }
      ])
    end

    specify 'fields missing in the dataset definition are skipped over' do
      dataset = build_dataset({})

      formatter = PayloadFormatter.new(dataset)

      payload = formatter.format([
        { 'favourite_chocolate' => 'galaxy' },
      ])

      expect(payload).to eq([
        { 'favourite_chocolate' => 'galaxy' },
      ])
    end

    def build_dataset(fields)
      Dataset.new(double, 'dataset.id', fields)
    end
  end
end
