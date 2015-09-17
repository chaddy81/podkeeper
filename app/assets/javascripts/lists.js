function change_list_item_user(){
  $('.list__item-new').submit(function(){
    if($(this).find('.list__name--select').is(':checked')){
      $(this).find('#list_item_user_id').val($(this).find('#pod-users').val())
      $(this).find('#list_item_sign_me_up').val(false)
    } else {
      $(this).find('#list_item_sign_me_up').val(true)
    }
  })
}

function remove_list_item(){
  $('.list__item-new [data-remove-row]').click(function(e) {
    e.preventDefault();
    $(this).parents('form').remove();
  });
}

$(function() {
  change_list_item_user()

  $('.list .icons__minimize').click(function(e) {
      e.preventDefault();
      var text = $(this).text();

      $(this).text(text == "Collapse" ? "Expand" : "Collapse");
      $(this).toggleClass('icons__minimize--open');
      $(this).parents('.list').next('.list__items').slideToggle();
  });

  remove_list_item()
});