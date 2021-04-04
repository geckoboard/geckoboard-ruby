# geckoboard-ruby
[![CircleCI](https://circleci.com/gh/geckoboard/geckoboard-ruby.svg?style=svg)](https://circleci.com/gh/geckoboard/geckoboard-ruby)

Ruby client library for Geckoboard (https://developer.geckoboard.com/api-reference/ruby).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'geckoboard-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install geckoboard-ruby

## Usage

### Require the gem

```ruby
require 'geckoboard'
```

### Ping to authenticate

Verify that your API key is valid and that you can reach the Geckoboard API.

```ruby
client = Geckoboard.client('222efc82e7933138077b1c2554439e15')
client.ping # => true
```

### Find or create

Verify an existing dataset or create a new one.

```ruby
dataset = client.datasets.find_or_create('sales.gross', fields: [
  Geckoboard::NumberField.new(:amount, name: 'Amount', optional: true),
  Geckoboard::MoneyField.new(:cost, name: 'Cost', currency_code: 'USD'),
  Geckoboard::DurationField.new(:span, name: 'Span', time_unit: 'seconds', optional: true),
  Geckoboard::DateTimeField.new(:timestamp, name: 'Time'),          
  Geckoboard::PercentageField.new(:completion, name: 'Completion'),
  Geckoboard::StringField.new(:company, name: 'Company')
], unique_by: [:timestamp])
```

Available field types:

- `NumberField`
- `MoneyField`
- `DurationField`
- `DateField`
- `DateTimeField`
- `PercentageField`
- `StringField`


`unique_by` is an optional array of one or more field names whose values will be unique across all your records.

### Delete

Delete a dataset and all data therein.

```ruby
dataset.delete # => true
```

Delete a dataset with a given id.

```ruby
client.datasets.delete('sales.gross') # => true
```

### Put

Replace all data in the dataset.

```ruby
dataset.put([
  {
    timestamp: DateTime.new(2016, 1, 2, 12, 0, 0),
    amount: 40900
  },
  {
    timestamp: DateTime.new(2016, 1, 3, 12, 0, 0),
    amount: 16400
  },
])
```

### Post

Append data to a dataset.

```ruby
dataset.post([
  {
    timestamp: DateTime.new(2016, 1, 2, 12, 0, 0),
    amount: 40900
  },
  {
    timestamp: DateTime.new(2016, 1, 3, 12, 0, 0),
    amount: 16400
  },
], delete_by: :timestamp)
```

`delete_by` is an optional field by which to order the truncation of records once the maximum record count has been reached. By default the oldest records (by insertion time) will be removed.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/geckoboard/geckoboard-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
