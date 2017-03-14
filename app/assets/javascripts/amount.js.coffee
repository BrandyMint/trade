document.addEventListener "turbolinks:load", ->
  $('[data-amount=input]').on 'change paste keyup', (event) ->
    console.log(event)
    $el = $(event.target)
    value =rubles $el.val()
    value = '' unless value
    $('[data-amount-hint]').text value
