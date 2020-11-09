# Tribe Code Challenge

## Setup

### install
```shell
git clone https://github.com/m8rix/code_challenge_201109.git
cd code_challenge_201109
bundle install
rails c
```

### run
```ruby
puts OrderPlacement::Order.text_summary_from_string_input("10 img 15 FLAC 13 Vid")
```
outputs
```
10 IMG $800.00
	1 x 10 $800.00
15 FLAC $1957.50
	1 x 9 $1147.50
	1 x 6 $810.00
13 VID $2370.00
	2 x 5 $900.00
	1 x 3 $570.00
```

### test
```shell
bundle exec rspec
```

## Spec analisis

From the spec

> Each order has a series of lines with each line containing the number of items followed by the submission
format code

An example input:
```
10 IMG 15 FLAC 13 VID
```

### Interpretation

> Each order has a series of lines

Given the example only displays one line, the assumption I make is that the example is in fact 3 lines, containing 3 tuples.

Each tuple represents the number of items followed by the submission
format code

Given the provided example I am going to assume both the lines and the tuples are both delimited by a _space_ and can be interpreted as follows:


```
10 IMG
15 FLAC
13 VID
```

## Vocabulary

```
[order]
(line)
{item}
<format>

[
  (
    {10 <IMG>}
  )
  (
    {15 <FLAC>}
  )
  (
    {13 <VID>}
  }
]
```

Given each **_line_** contains one **_item_** we will refer to these as **_LineItems_**
_quantity_ and _format_ will be attributes of a `LineItem`

### Data Vocabulary

 | Submission format | Format code | Bundles |
 | --- | --- | --- |
 | Image | IMG | 5 @ $450<br>10 @ $800 |
 | Audio | Flac | 3 @ $427.50<br>6 @ $810<br>9 @ $1147.50 |
 | Video | VID | 3 @ $570<br>5 @ $900<br>9 @ $1530 |

A **_submission_format_** defines and represents an item that can be ordered. Each submission has a unique **_format_code_** and can be associated with one or more **_bundling_** options

I will attempt to align data modelling to these understood terms as closely as possible whilst using commonly understood terms where it makes sense to do so.

![](https://i.imgur.com/bCTO6qC.png)


### OrderPlacement Service

The word _"Order"_ can be ambiguous as it is also used to describe the arrangement of values. The vocabulary I have chosen is to retain the word _"Order"_ but adds _"Placement"_ to provide a clearer meaning for what the service is responsible for.

This name space will be reserved for any logic pertaining to the placement of orders.

#### OrderPlacement::Order

Main responsibility: OrderPlacement service interface, handle usecases in wraped service methods

i.e. usecase: print order summary
```ruby
input = '10 IMG 15 FLAC 13 VID'
line_items = OrderPlacement::Inputs.line_items_from_string_input(input)
order = OrderPlacement::Order.new(line_items)

puts order.text_summary
```

will be wrapped into
```ruby
puts OrderPlacement::Order.text_summary_from_string_input("10 img 15 FLAC 13 Vid")
```

#### OrderPlacement::LineItem

Main responsibility: Holds LineItem instances

#### OrderPlacement::Inputs

Main responsibility: Converting various inputs into LineItems, a format understood by the service

#### OrderPlacement::Bundler

Main responsibility: Holds the business logic around how orders shall be bundled

#### OrderPlacement::OrderTuples

Main responsibility: Any handling of order placement tuples (manipulation, conversion, validation, etc...)


## Extendability

We can implement more usecases into the `OrderPlacement::Order` class, such as save/persist order data, validation feedback, etc...

## Collaboration
There are a number of decisions that would call for some collaboration for this feature.

1. Naming conventions that make sense
    - _quantity:_ There is the quantity of a bundle submission, quantity of the order, quantity of the number of bundles. I see some benefit to deciding on an agreed set of terms to be used throughout the code.
    - _price:_ Similarly to quantity, we have order total, line total, bundle total and bundle price. Again I would see some benefit to talking to the product team and align terminology and definitions.
    - _item:_ Line item, bundle item, items in a bundle
2. Optimal bundle allocations
    - It appears there is one tricky part to this feature. That being; how to determine the correct bundles needed to match the overall order quantity. I feel this would be worth a second opinion on how to structure this in a way that is easy to follow. And this kind of problem is usually enjoyed by other engineers so I would feel an obligation in sharing it with collegues.
