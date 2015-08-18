$(function() {
  $('.footer select').on('change', function() {
    var link_href = $(this).find('option:selected').data('link-href');
    window.location.assign(link_href);
  });
});