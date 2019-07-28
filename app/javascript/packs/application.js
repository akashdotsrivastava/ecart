// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
import 'bootstrap'
import './src/application.scss'


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
var cartId

$(document).ready(() => {
  // $("#notice").fadeOut(3000);
  setCart()
  repaintPage()
  setInterval(repaintPage, 8000)
})

var setCart = () => {
  $.get('/api/v1/carts.json', (data) => {
    if (data.length == 1){
      cartId = data[0].id
    }
    else {
      $.post('/api/v1/carts.json', {}, (data) => {
        cartId = data.id
      })
    }
  })
}

var repaintPage = () => {
  let productsTable = document.getElementById('products-table')
  let productsTableBody = document.getElementById('products-table-body')
  document.querySelectorAll('.products_row').forEach((ele) => {
    // removing the table rows
    ele.parentElement.removeChild(ele)

  })
  $.get('/api/v1/items.json', (data) => {
    $.get('/api/v1/item_discounts.json', (discount_data) => {
      data.forEach((productInfo) => {
        let row = document.createElement('tr')
        row.classList.add('products_row')
        row.dataset.itemId = productInfo.id

        let prodName = document.createElement('td')
        prodName.innerText = productInfo.name
        row.append(prodName)

        let prodPrice = document.createElement('td')
        prodPrice.innerText = `Rs. ${productInfo.price}`
        row.append(prodPrice)

        let discounts = document.createElement('td')
        
        let discountsUl = document.createElement('ul')
        discount_data.filter((discount) => { return (discount.item_id == productInfo.id)}).forEach((discountInfo) => {
          let discountLi = document.createElement('li')
          discountLi.innerText = `Buy ${discountInfo.quantity}, get Rs. ${discountInfo.discount} off`
          discountLi.classList.add('text-success')
          discountsUl.append(discountLi)
        })
        discounts.append(discountsUl)
        row.append(discounts)

        let inCart = document.createElement('td')
        inCart.innerText = ''
        inCart.id = `inCartCount_${productInfo.id}`
        row.append(inCart)

        let addToCart = document.createElement('td')
        let addToCartButton = document.createElement('button')
        addToCartButton.classList.add('btn')
        addToCartButton.classList.add('btn-primary')
        addToCartButton.classList.add('add-to-cart-btn')
        if(cartId){
          addToCartButton.dataset.cartId = cartId
          addToCartButton.dataset.itemId = productInfo.id
          addToCartButton.innerText = 'Add to Cart'
          addToCart.append(addToCartButton)
        }
        row.append(addToCart)

        productsTableBody.append(row)
      })
    })
    
  })
  updateCartStats()
}

var updateCartStats = () => {
  if(cartId){
    $.get(`/api/v1/carts/${cartId}/items_carts.json`, (data) => {
      let cartItems = data.cart_items
      let cartItemsCount = document.getElementById('items_cart_count')
      cartItemsCount.innerText = cartItems.length

      let cartTbody = document.getElementById('cartTableTbody')
      document.querySelectorAll('.cart_products_row').forEach((ele) => {
        ele.parentElement.removeChild(ele)
      })
      cartItems.forEach((cartItem) => {
        let inCartElement = document.getElementById(`inCartCount_${cartItem.item_id}`)
        if(inCartElement)
          inCartElement.innerText = cartItem.quantity
        
        let cartRow = document.createElement('tr')
        cartRow.classList.add('cart_products_row')

        let td1 = document.createElement('td')
        td1.innerText = cartItem.name
        cartRow.append(td1)

        let td2 = document.createElement('td')
        td2.innerText = cartItem.quantity
        cartRow.append(td2)

        let td3 = document.createElement('td')
        td3.innerText = `Rs. ${cartItem.total_price}`
        cartRow.append(td3)

        let td4 = document.createElement('td')
        td4.innerText = (cartItem.total_discount == 0 ? 0 : `Rs. ${cartItem.total_discount}` )
        cartRow.append(td4)

        let td5 = document.createElement('td')
        td5.innerText = `Rs. ${cartItem.final_price}`
        cartRow.append(td5)

        cartTbody.append(cartRow)

      })
      
      let cR1 = document.createElement('tr')
      cR1.classList.add('cart_products_row')
      cR1.append(document.createElement('td'))
      cR1.append(document.createElement('td'))
      cR1.append(document.createElement('td'))
      let td1 = document.createElement('td')
      td1.innerHTML = '<b>Total Cart Value</b>'
      cR1.append(td1)
      let td2 = document.createElement('td')
      td2.innerText = `Rs. ${data.cart_price}`
      cR1.append(td2)
      cartTbody.append(cR1)

      let cR2 = document.createElement('tr')
      cR2.classList.add('cart_products_row')
      cR2.append(document.createElement('td'))
      cR2.append(document.createElement('td'))
      cR2.append(document.createElement('td'))
      let td3 = document.createElement('td')
      td3.innerHTML = '<b>Cart Discount</b>'
      cR2.append(td3)
      let td4 = document.createElement('td')
      td4.innerText = `Rs. ${data.cart_discount}`
      cR2.append(td4)
      cartTbody.append(cR2)

      let cR3 = document.createElement('tr')
      cR3.classList.add('cart_products_row')
      cR3.append(document.createElement('td'))
      cR3.append(document.createElement('td'))
      cR3.append(document.createElement('td'))
      let td5 = document.createElement('td')
      td5.innerHTML = '<b>Amount to pay</b>'
      cR3.append(td5)
      let td6 = document.createElement('td')
      td6.innerHTML = `<b>Rs. ${data.amount_to_pay}</b>`
      cR3.append(td6)
      cartTbody.append(cR3)

    })
  }
}

$(document).on('click', '.add-to-cart-btn', (event) => {
  let cartToBeAddedId = event.target.dataset.cartId
  let itemToBeAddedId = event.target.dataset.itemId
  $.post(`/api/v1/carts/${cartToBeAddedId}/items_carts.json`, {items_cart: { item_id: itemToBeAddedId }}, (data) => {
    if(data.id){
      $('#notice').html('Item Successfully added to cart')
      updateCartStats()
    }
    else{
      $('#error').html('Item Could not be added')
    }
  })
})


