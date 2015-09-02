$(function() {
  $('.pod-nav__pod-name').on('click', function() {
    $('.pod-select__overlay').toggleClass('active');
    if($('.pod-select__overlay.active').length) {
      $('body').addClass('no-scroll');
    }else{
      $('body').removeClass('no-scroll');
    }
  });

  $('.pod-select__pod').on('click', function() {
    $('.pod-select__overlay').toggleClass('active');
  });
});