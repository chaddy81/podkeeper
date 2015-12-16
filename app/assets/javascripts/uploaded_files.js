$(function() {

  // hackish fix here
  // if there's a flash message on the page, that means they either just successfully or unsuccessfully attempted to upload a file
  // in that case, leave the form open. Only close it if they're coming to this page fresh.
  if ($('.alert').length < 1) {
    $('.with-border [data-show-form]').hide();
  }

  $('[data-new-file]').click(function(e) {
    e.preventDefault();
    $(this).parent().find('form').slideToggle();
    $(this).toggleClass('selected');
  });

  // $('#uploaded_file_file').change(function() {
  //   $(this).parents('form').submit();
  // });

  $('[data-cancel-description-edit]').click(function() {
    originalDescription = $('[data-original-description]').text();
    $(this).parents('td').html(originalDescription);
    return false;
  });

  $('.corkboard-note').on('submit', function(){
    $('.save-message').show();
  });

});