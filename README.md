# README

**Running the server up**

In the app root directory:

```
1. bundle install
2. yarn install --check-files
3. rake db:migrate
4. rake db:seed
```

then:

```
foreman start
```

it will start the rails server along with webpacker. The ports for both of these lie in `Procfile`. They can be changed if needed. By default the rails server runs on `localhost:3010`

**Running the tests**

In the app root directory:

```
rails test
```

The model and controller test cases test unit logic while `t/i/complete_flow_test` tests full flow as per specification and tests for exact scenarios

**Apis**

1. GET */api/v1/items.json* (intially contained just name and price, now also contains id for using in front end views)
2. POST */api/v1/carts/:cart_id/items_carts.json* with params: *{ items_cart: { item_id: :item_id } }* to add an item `:item_id` to cart `:cart_id`
3. GET */api/v1/carts/:cart_id/items_carts.json* to get details of a cart. Includes the products/items, their quantity, price, discount, final price for each and then total cart value, cart discount, and final amount to pay

For examples given in spec. After `rake db:seed`, check the following apis through browser or curl

1. `/api/v1/items.json`
2. `/api/v1/carts/1/items_carts.json`
3. `/api/v1/carts/2/items_carts.json`
4. `/api/v1/carts/3/items_carts.json`
5. `/api/v1/carts/4/items_carts.json`

**App Views**

The front end is available directly at `localhost:3010`. It assumes the first cart id if present and if not creates a new cart on load. Then it display list of products available, their per unit price, the discounts available on them, the quantity you already have in your cart and an add to cart button.

The My Cart option opens up a modal which shows up your cart. It contains all the items in your cart, their quantities, discounts applied and the final price for each. At the end it shows the full cart price, the cart discount and the final amount to pay

**Small Assumptions and ReadUP**

1. Item discount(model ItemDiscount) has been designed as under:
    a. an item discount, will contain an `item_id` with two values `quantity` and `discount`. That means for each buying of `quantity` no of items `item_id`, a Rs `discount` discount is applied.
    b. One can add many such item discounts to an item. The final discount applied, will be the one with most quantity, less than or equal to quantity of the product in cart. If there are two or more such (applied on same highest quantity), the one with most discount will be chosen.
    c. 0.0 item discount if no item discount, or no active item discount is found
    d. The main invokation of discount on items is called from `Item.discount_for_quantity(quantity)` method. Future methods for adding other item discounts can be added here.

2. Cart discount(model CartDiscount) has been designed as under:
    a. a cart discount, will contain a `total_basket_price` and an `additional discount`. That means for each cart value more than or equal to Rs `total_basket_price`, there will be Rs `additional_discount` discount applied finally on the total cart value
    b. One can add many cart discounts. The final discount applied, will be the one with the most `total_basket_price`, less than or equal to total cart value after all item discounts. The there are two or more such cart discounts (applicable on same `total_basket_price`), the one with most additional discount will be chosen.
    c. 0.0 cart discount, if no cart discount or no active cart discount is found.
    d. The main invokation of discount on cart is called from `Cart.cart_discount_for(cart_price)` method. Future methods for adding other cart discounts can be added here.

3. Most of the json forming logic for the APIs, sits in the serializers. `Api::V1::ItemSerializer` builds the items json in items api. `Api::V1::CartItemSerializer` builds the individual cart item details and `Api::V!::CartItemsSerializer` builds the the complete cart details

4. Other controllers and serializers not mentioned in these docs are simply there to support the front end views and are verbose themselves
5. The front end is a combination of javascript DOM manipulation and jQuery.


