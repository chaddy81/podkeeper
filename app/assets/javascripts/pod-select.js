$(function() {
  $('.pod-nav__pod-name').on('click', function() {
    $('.pod-select__overlay').toggleClass('active');
  });

  $('.pod-select__pod').on('click', function() {
    $('.pod-select__overlay').toggleClass('active');
  });
});