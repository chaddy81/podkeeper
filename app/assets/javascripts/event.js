$(function() {
  $(document).on('click', '.rsvp-count__edit, .button-container label', function() {
    $('.rsvp-count-comment').show();
    $('.rsvp-count__user, .rsvp-comment').hide();
  });

  $(document).on('click', '.rsvp-count-comment .cancel', function() {
    $('.rsvp-count-comment').hide();
    $('.rsvp-count__user, .rsvp-comment').show();
  });

  $('#new_rsvp .cancel').on('click', function(e) {
    e.preventDefault();
    $('.rsvp-count-comment').hide();
  });

  $(document).on('click', '.rsvp-users', function() {
    $('.rsvp-results').removeClass('active');
    if($(this).hasClass('rsvp-users--yes')) {
      if ($('.rsvp-results--yes').length) {
        $('.rsvp-results--yes').addClass('active');
        window.scrollTo(0, $('.rsvp-results--yes')[0].offsetTop);
      }
    } else if($(this).hasClass('rsvp-users--no')) {
      if ($('.rsvp-results--no').length) {
        $('.rsvp-results--no').addClass('active');
        window.scrollTo(0, $('.rsvp-results--no')[0].offsetTop);
      }
    } else if($(this).hasClass('rsvp-users--maybe')) {
      if ($('.rsvp-results--maybe').length) {
        $('.rsvp-results--maybe').addClass('active');
        window.scrollTo(0, $('.rsvp-results--maybe')[0].offsetTop);
      }
    } else if($(this).hasClass('rsvp-users--rsvp')) {
      if ($('.rsvp-results--needed').length) {
        $('.rsvp-results--needed').addClass('active');
        window.scrollTo(0, $('.rsvp-results--needed')[0].offsetTop);
      }
    }
  });

  // $("form[id^=edit_rsvp_]").on("ajax:success", function(e, data, status, xhr) {
  //   $('.error-messages .alert').addClass('alert-success').text('RSVP was updated successfully!');
  // }).on("ajax:error", function(e, xhr, status, error) {
  //   $('.error-messages .alert').addClass('alert-danger').text(xhr.responseText);
  // });
});