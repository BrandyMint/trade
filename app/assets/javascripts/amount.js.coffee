document.addEventListener "turbolinks:load", ->
  console.debug? "Init amount"
  $('[data-amount=input]').on 'change paste keyup', (event) ->
    console.log(event)
    $el = $(event.target)
    $('[data-amount=string]').text rubles $el.val()
