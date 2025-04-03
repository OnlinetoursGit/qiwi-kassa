# Qiwi::Kassa

Ruby wrapper to interact with QIWI Kassa [API v1.21](https://developer.qiwi.com/ru/payments/#get-started).

To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qiwi-kassa'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qiwi-kassa

## Usage

### Interact with API

#### Initialize `api` object:
```ruby
api = Qiwi::Kassa::Api.new(secret_key: "xxx-yyy-zzz", provider: :pay2me)
```
Valid values for the `provider` parameter - `qiwi` | `pay2me`. The default value is `qiwi`.

Optional param `host`
```ruby
api = Qiwi::Kassa::Api.new(secret_key: "xxx-yyy-zzz", provider: :pay2me, host: "https://alternative.api.host")
```
In case `host` does not passed default hosts used:
 - 'https://api.qiwi.com' for `qiwi`,
 - 'https://api.pay2me.com' for `pay2me`.

#### Create invoice ([api doc](https://developer.qiwi.com/ru/payments/#invoice_put)):
```ruby
api.resources.bills.create(id: "invoice_id", site_id: "site_id", params: { amount: { currency: "RUB", value: "10.00" }, expirationDateTime: "2024-04-29T14:12:45+03:00" })
```

#### Invoice status ([api doc](https://developer.qiwi.com/ru/payments/#invoice-details)):
```ruby
api.resources.bills.status(id: "invoice_id", site_id: "site_id")
```

#### Invoice payments ([api doc](https://developer.qiwi.com/ru/payments/#invoice-payments)):
```ruby
api.resources.bills.payments(id: "invoice_id", site_id: "site_id")
```

#### Capture create ([api doc](https://developer.qiwi.com/ru/payments/#capture)):
```ruby
api.resources.captures.create(payment_id: "payment_id", capture_id: "capture_id", site_id: "site_id")
```

#### Capture status ([api doc](https://developer.qiwi.com/ru/payments/#capture_get)):
```ruby
api.resources.captures.status(payment_id: "payment_id", capture_id: "capture_id", site_id: "site_id")
```

#### Refund create ([api doc](https://developer.qiwi.com/ru/payments/#refund-api)):
```ruby
api.resources.refunds.create(payment_id: "payment_id", refund_id: "refund_id", site_id: "site_id")
```

#### Refund status ([api doc](https://developer.qiwi.com/ru/payments/#refund-api-status)):
```ruby
api.resources.refunds.status(payment_id: "payment_id", refund_id: "refund_id", site_id: "site_id")
```

#### Refunds statuses ([api doc](https://developer.qiwi.com/ru/payments/#refunds-api-status)):
```ruby
api.resources.refunds.statuses(payment_id: "payment_id", site_id: "site_id")
```

### Server notification ([api doc](https://developer.qiwi.com/ru/payments/#callback))

#### Build notification inside your callback controller:
```ruby
notification = Qiwi::Kassa::Notification.new(data: notification_params)
```

#### Check is notification valid:
```ruby
notification.valid?(secret_key: notification_secret_key, signature: request.headers["Signature"])
```

### Build WPF invoice url ([doc](https://developer.qiwi.com/ru/payments/#https-qiwi-form))

```ruby
params = {
           publicKey: 'Fnzr1yTebUiQaBLDnebLMMxL8nc6FF5zfmGQnypc*******',
           amount: 100,
           billId: '893794793973',
           successUrl: 'https://test.ru',
           email: 'test@test.ru'
         }

Qiwi::Kassa::PaymentForm.build(params: params)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Run tests

bundle exec rake spec

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/qiwi-kassa. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Qiwi::Kassa project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/qiwi-kassa/blob/master/CODE_OF_CONDUCT.md).
