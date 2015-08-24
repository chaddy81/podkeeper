$(function() {
  $('.home-page__nav a').on('click', function(e) {
    e.preventDefault();

    var $target = $(this).attr('href');

    $('html, body').animate({
      scrollTop: $($target).offset().top + 'px'
    }, 500);
  });
});