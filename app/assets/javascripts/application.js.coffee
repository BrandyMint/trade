#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require nprogress
#= require nprogress-turbolinks
#= require tether
#= require cocoon
#= require better-dom
#= require better-i18n-plugin
#= require better-popover-plugin
#= require better-form-validation
#= require better-form-validation/i18n/better-form-validation.ru
#= require bootstrap
#= require tinymce-jquery
#= require rubles/lib/rubles
#= require amount
#= require dadata
#= require custom_dropzone

DOM.set("lang", "ru")

document.addEventListener "turbolinks:load", ->
  # Lightbox.enable();

  tinyMCE.init
    selector: '[data-editor]'
    plugins: ['table', 'link']
    menubar: false
    toolbar: ['table | styleselect | bold italic | undo redo | link']


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
