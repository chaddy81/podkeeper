$(function() {

  // expand/collapse description
  // $('.open-invites .full').hide();
  $('.open-invites .expand').click(function() {
      if ($(this).parent().is(':visible')) {
        $(this).parent().fadeOut(50, function() {
            $(this).parents().find('.full').fadeIn(50);
        });
      } else {
        $(this).parents().find('.full').fadeOut(50, function() {
            $(this).parent().fadeIn(50);
        });
      }
  });

        // TODO: This is breaking some JS. Fix before uncomment
  // $('.carousel').carousel({ interval: 3000 });

  $('[data-select-all]').change(function() {
    if ($(this).is(':checked')) {
      $('input[type="checkbox"]').prop('checked', true)
    } else {
      $('input[type="checkbox"]').prop('checked', false)
    }
  });

});