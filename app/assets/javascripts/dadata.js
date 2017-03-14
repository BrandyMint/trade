function setValue(key, value) {
  var el = $('[data-suggestion='+key+']');
  el.val(value);
  el.attr('placeholder', '');
}

document.addEventListener("turbolinks:load", function() {

  $("[data-suggestion=bank]").suggestions({
    serviceUrl: "https://suggestions.dadata.ru/suggestions/api/4_1/rs",
    token: "ec38fd33bb97b81c71dfb0161edf994acc0825f9",
    type: "BANK",
    count: 5,
    /* Вызывается, когда пользователь выбирает одну из подсказок */
    onSelect: function(suggestion) {
      console.log('bik suggestion', suggestion);

      setValue('bik', suggestion.data.bic);
      setValue('ks_number', suggestion.data.correspondent_account);
    }
  });

  $("[data-suggestion=party]").suggestions({
    serviceUrl: "https://suggestions.dadata.ru/suggestions/api/4_1/rs",
    token: "ec38fd33bb97b81c71dfb0161edf994acc0825f9",
    type: "PARTY",
    count: 5,
    /* Вызывается, когда пользователь выбирает одну из подсказок */
    onSelect: function(suggestion) {
      console.log('party suggestion', suggestion);
      setValue('inn', suggestion.data.inn);
      setValue('ogrn', suggestion.data.ogrn);
      setValue('kpp', suggestion.data.kpp);
      setValue('address', suggestion.data.address.value);
      setValue('name', suggestion.data.name.short_with_opf);
      setValue('type', suggestion.data.type);

      if (suggestion.data.management) {
        setValue('management-post', suggestion.data.management.post);
        setValue('management-name', suggestion.data.management.name);
      } else {
        if (suggestion.data.type == 'INDIVIDUAL') {
          setValue('management-post', 'директор');
          setValue('management-name', suggestion.data.name.full);
        }
      }
    }
  });

});
