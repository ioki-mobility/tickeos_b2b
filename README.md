# TICKeosB2B API

[![CI for tickeos_b2b](https://github.com/ioki-mobility/tickeos_b2b/workflows/CI%20for%20tickeos_b2b/badge.svg)](https://github.com/ioki-mobility/tickeos_b2b/actions)

Ruby bindings for the TICKeosB2B API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tickeos_b2b'
```

And then execute:

```ruby
bundle install
```

Or install it yourself as:

```ruby
gem install tickeos_b2b
```

## Usage

First create a new instance of the `TickeosB2b::Client` class. The following method parameters are needed for the authentication:

- `url` (e.g. https://shop.tickeos.de/service.php/tickeos_proxy)
- `username`
- `password`

**Example:**
```ruby
tickeos = TickeosB2b::Client.new(url, username, password)
```

Then use one of the following methods to interact with the TICKeos B2B API:

- [`product_list`](#`product_list`)
- [`product_data`](#`product_data`)
- [`purchase`](`#purchase`)
- [`order`](`#order`)

### #`product_list`

The `product_list` method returns a list of all available tickets with their **name** and **reference_id**.

No parameters are needed.

**Example:**
```ruby
tickeos.product_list
```

### #`product_data`

The `product_data` method returns more details about a requested ticket.

**Needed parameters:**

- `ref_id` (Ticket reference ID)

**Example:**
```ruby
ref_id = 'example-ticket'

tickeos.product_data(ref_id)
```

### #`purchase`

The `purchase` method is used to purchase a selected product. In case of a successful purchase, the response contains the order number (`server_ordering_serial`) and the serial product number (`server_order_product_serial`) as well as necessary data of the purchased product. In case of an error, the error codes and detailed error messages can be found in the response.

**Needed parameters:**

- `pre_check`
- `go`
- `**options`

|Description|`pre_check`|`go`|
|-|-|-|
|Validation before an order|1|0|
|Validation after an order|0|0|
|Validation and generation of an order|0|1|

```ruby
options = {
  :serial_ordering,  # Unique ordering id
  :first_name,       # First name
  :last_name,        # Last name
  :ref_id,           # Ticket reference id
  :quantity,         # Number of tickets
  :serial_product,   # Ticket id
  :date_to_validate, # Validation date (time can also be passed, but it must have a CET/CEST timezone attached to it)
  :location_id,      # Location id (for communication with HAFAS)
  :sub_ref_id,       # Subproduct reference id
  :transaction_id,   # Payment transaction id
  :payed_amount      # Payed amount
}
```

**Example:**
```ruby
pre_check = '0' # default
go        = '1' # default

options = {
  ref_id:           'Ganztagesticket',
  first_name:       'Json',
  last_name:        'Statham',
  serial_ordering:  'unique_id_123',
  serial_product:   '123',
  date_to_validate: ActiveSupport::TimeZone['Berlin'].now,
  sub_ref_id:       'AB',
  transaction_id:   '2L1JHBFT49TC1',
  quantity:         '1',
  payed_amount:     '7.66'
}

tickeos.purchase(pre_check, go, options)
```

### #`order`

The `order` method retrieves the purchased ticket from the TICKeosB2B API. To retrieve a ticket a `server_ordering_serial` and `server_order_product_serial` parameter is needed. Both parameters are returned after a successful purchase.

**Needed parameters:**

- `server_ordering_serial` (order number on eos.uptrade server)
- `server_order_product_serial` (product serial number (ticket ID) on eos.uptrade server)

**Example:**
```ruby
server_ordering_serial      = '42'
server_order_product_serial = '0815'

tickeos.order(server_ordering_serial, server_order_product_serial)
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags.

## Testing

After checking out the repo, run `bin/setup` or `bundle` to install all dependencies. Then, run `rake spec` or `rake` to run the tests. To use an interactive prompt that allows some manual testing of the gem, simply run `bin/console` and you're good to go.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dbdrive/tickeos_b2b.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
