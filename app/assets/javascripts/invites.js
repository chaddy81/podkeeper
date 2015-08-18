$(function() {

  // expand/collapse description
  // $('.open-invites .full').hide();
  $('.open-invites .expand').click(function() {
      $(this).toggleClass('switch');
      if ($(this).siblings('.preview').is(':visible')) {
        $(this).siblings('.preview').fadeOut(50, function() {
            $(this).siblings('.full').fadeIn(50);
        });
      } else {
        $(this).siblings('.full').fadeOut(50, function() {
            $(this).siblings('.preview').fadeIn(50);
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