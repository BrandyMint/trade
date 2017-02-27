$ ->
  $("[data-toggle='tooltip']").tooltip()
  $("[data-toggle='popover']").popover()

  $("[data-banner-close]").on 'click', (event) ->
    console.debug? event
    $e = $ event.target
    id = $e.data 'banner-close'

    $.ajax
      url: "/banners/" + id
      contentType: "application/json; charset=utf-8"
      dataType: "json"
      type: 'DELETE'
      xhrFields:
        withCredentials: true
