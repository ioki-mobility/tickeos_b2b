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

First create a new instance of the `TickeosB2b::Client` class. The following method parameters are required for the authentication:

- `url` (e.g. https://shop.tickeos.de/service.php/tickeos_proxy)
- `username`
- `password`

**Example:**
```ruby
tickeos = TickeosB2b::Client.new(url, username, password)
```

After initializing a new instance of `TickeosB2b::Client` use one of the following methods to interact with the TICKeos B2B API:

- [`product_list`](#product_list)
- [`load!`](#load!)
- [`personalize`](#personalize)
- [`purchase`](#purchase)
- [`order`](#order)

### product_list

The instance method `product_list` returns an array of all available `Product` objects with their **name** and **reference_id**. In this case products are synonymous with tickets.

No parameters required.

**Example:**
```ruby
products = tickeos.product_list
products
```

**Response:**
```ruby
[
  [0] #<TickeosB2b::Product:0x00007fa262226b70 @name="Einzelkarte", @reference_id="EK", @updated_at=2020-08-05 13:32:06 +0200, @published=true, @id=nil, @vu_name=nil, @vu_role=nil, @sort_order=nil, @tariff_zone_count=nil, @tariff_zone_count_required=nil, @sale_date_from=nil, @sale_date_to=nil, @distribution_method=nil, @visible=nil>,
  [1] #<TickeosB2b::Product:0x00007fa262226648 @name="Einzelkarte Kind", @reference_id="EK Kind", @updated_at=2020-08-05 13:32:06 +0200, @published=true, @id=nil, @vu_name=nil, @vu_role=nil, @sort_order=nil, @tariff_zone_count=nil, @tariff_zone_count_required=nil, @sale_date_from=nil, @sale_date_to=nil, @distribution_method=nil, @visible=nil>
]
```

### load!

The `load!` method returns more details about a requested ticket and attaches the additional information to the `Product` object.

**Required parameters:**

- `product` (A single `Product` object retrieved from `product_list` call)

**Example:**
```ruby
product = products.first

tickeos.load!(product)
```

**Response:**
```ruby
#<TickeosB2b::Product:0x00007fa262226b70 @name="Einzelkarte", @reference_id="EK", @updated_at=2020-08-05 13:32:06 +0200, @published=true, @id="357", @vu_name="", @vu_role="", @sort_order="1", @tariff_zone_count="0", @tariff_zone_count_required="", @sale_date_from=2019-11-11 00:00:00 +0000, @sale_date_to="", @distribution_method="mobile_ticket", @visible=true>
```

### personalize

The `personalize` method adds personalized data to a selected product and initializes a Ticket object. This step is optional and can be skipped if the purchase method is provided with a loaded `product` and `personalisation_data`.

**Required parameters:**

- `personalisation_data`

**Example:**
```ruby
personalisation_data = {
  first_name:      'Json',
  last_name:       'Statham',
  validation_date: Time.now,
  sub_ref_id:      'no_surcharge'
}

ticket = product.personalize(personalisation_data)
ticket
```

**Response:**
```ruby
#<TickeosB2b::Ticket:0x00007fa2629b0dc8 @state=:new, @product=#<TickeosB2b::Product:0x00007fa262226b70 @name="Einzelkarte", @reference_id="EK", @updated_at=2020-08-05 13:32:06 +0200, @published=true, @id="357", @vu_name="", @vu_role="", @sort_order="1", @tariff_zone_count="0", @tariff_zone_count_required="", @sale_date_from=2019-11-11 00:00:00 +0000, @sale_date_to="", @distribution_method="mobile_ticket", @visible=true>, @product_reference_id="EK", @errors=nil, @serial_ordering="ord_8869c196-94b5-4952-b1d5-e73c6358b2aa", @transaction_id="tra_68c30d7c-f9ff-4a70-8dec-242c1aced3c5", @sub_ref_id="no_surcharge", @validation_date=2020-10-07 15:19:02 +0200, @first_name="Json", @last_name="Statham", @server_ordering_serial=nil, @server_order_product_serial=nil, @price_net=nil, @price_gross=nil, @price_vat=nil, @price_vat_rate=nil>
```

### purchase

The `purchase` method is used to purchase a selected product. The user has two options here:

1. purchase a ticket after using the `personalize` method

**Required parameters:**

- `product` (needs to be nil)
- `personalisation_data` (needs to be nil)
- `ticket`

**Optional parameters:**

- `precheck` (default is 0)
- `go` (default is 1)

**Example:**

```ruby
purchased_ticket = tickeos.purchase(product = nil, personalisation_data = nil, ticket)
purchased_ticket
```

**Response:**
```ruby
#<TickeosB2b::Ticket:0x00007fa2629b0dc8 @state=:invalid, @product=#<TickeosB2b::Product:0x00007fa262226b70 @name="Einzelkarte", @reference_id="EK", @updated_at=2020-08-05 13:32:06 +0200, @published=true, @id="357", @vu_name="", @vu_role="", @sort_order="1", @tariff_zone_count="0", @tariff_zone_count_required="", @sale_date_from=2019-11-11 00:00:00 +0000, @sale_date_to="", @distribution_method="mobile_ticket", @visible=true>, @product_reference_id="EK", @errors={:error_type=>:validation_error, :error_product=>[{"@serial_number"=>"357", "@product_id"=>"357", "@field_type"=>"field", "@field_name"=>"validation_date", "@error_message"=>"kein gültiges Datum ausgewählt", "@error_code"=>"min"}, {"@serial_number"=>"357", "@product_id"=>"357", "@field_type"=>"field", "@field_name"=>"location", "@error_message"=>"Eingabe konnte nicht geprüft werden.", "@error_code"=>"soap"}], :error_payment=>nil, :error_customer=>nil, :error_code=>"0300", :error_message=>"validation errors while processing purchase request"}, @serial_ordering="ord_8869c196-94b5-4952-b1d5-e73c6358b2aa", @transaction_id="tra_68c30d7c-f9ff-4a70-8dec-242c1aced3c5", @sub_ref_id="no_surcharge", @validation_date=2020-10-07 15:19:02 +0200, @first_name="Json", @last_name="Statham", @server_ordering_serial=nil, @server_order_product_serial=nil, @price_net=nil, @price_gross=nil, @price_vat=nil, @price_vat_rate=nil>
```

2. purchase a ticket with a *loaded* product and personalisation data

**Required parameters:**

- `product`
- `personalisation_data`

**Optional parameters:**

- `precheck` (default is 0)
- `go` (default is 1)



In case of a successful purchase, the response contains the order number (`server_ordering_serial`) and the serial product number (`server_order_product_serial`) besides other ticket relevant data such as information about prices and vat rate. In case of an error, the error codes and detailed error messages will be returned.

**Required parameters:**

- `pre_check`
- `go`
- `**options`

|Description|`pre_check`|`go`|
|-|-|-|
|Validation before an order|1|0|
|Validation after an order|0|0|
|Validation and generation of an order|0|1|

```ruby

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
  date_to_validate: Time.now,
  sub_ref_id:       'AB',
  transaction_id:   '2L1JHBFT49TC1',
  quantity:         '1',
  payed_amount:     '7.66'
}

tickeos.purchase(pre_check, go, options)
```

### order

The `order` method retrieves the purchased ticket from the TICKeosB2B API. To retrieve a ticket a `server_ordering_serial` and `server_order_product_serial` parameter is needed. Both parameters are returned after a successful purchase.

**Required parameters:**

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
