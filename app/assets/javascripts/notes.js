$(function() {

  $('#note_topic').on('input', function(e) {
      remaining = 60 - $('#note_topic').val().length;
      $('#topic-counter').text(remaining + ' / 60 characters');
      $('#note_topic_count').val(remaining);
      if (remaining < 0) {
        $('#topic-counter').addClass('red');
        $('#topic-counter').append('<br>Topic is limited to 60 characters');
      } else {
        $('#topic-counter').removeClass('red');
      }
    });

    $('#note_body').on('input', function(e) {
      remaining = 2000 - $('#note_body').val().length;
      $('#details-counter').text(remaining + ' / 2000 characters');
      $('#note_body_count').val(remaining);
      if (remaining < 0) {
        $('#details-counter').addClass('red');
        $('#details-counter').append('<br>Details are limited to 2000 characters');
      } else {
        $('#details-counter').removeClass('red');
      }
    });

    if ( $('#note_topic').val() ) {
      $('#note_topic_count').val( 60 - $('#note_topic').val().length );
    }

    if ( $('#note_body').val() ) {
      $('#note_body_count').val( 2000 - $('#note_body').val().length );
    }

});
