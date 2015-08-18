$(function() {
    // Settings - password
    if ($('.password.error').length <= 0) {
        $('.update-info__password .optional-fields').hide();
    }

    $('.update-info__password h4').click(function() {
        $(this).toggleClass('expand');
    });

    $(".timezone option[value='line']").replaceWith('<optgroup label="----------------------"></optgroup>');

    $('form.daily-digest input:checkbox').click(function(e) {
        if($(this).attr('checked') !== "checked") {
            $('.decline-daily-digest').modal();
        }else{
            $('.daily-digest').submit();
            $('.confirm-daily-digest').modal();
        }
    });

    $('.decline-daily-digest .select').click(function() {
        $('.daily-digest input:checkbox').attr('checked', false);
        $('.daily-digest').submit();
        $('.decline-daily-digest').modal('hide');
    });

    $('.decline-daily-digest .cancel').click(function() {
        $('.daily-digest input:checkbox').attr('checked', true);
        $('.decline-daily-digest').modal('hide');
    });

    $('#user_phone').mask('?999-999-9999');

    $('[data-reset-password]').click(function(e){
      e.preventDefault();
      $('#user_password').val('');
      $('#user_password_confirmation').val('');
    })

    // $('a[data-pod-id]').click(function(e) {
    //     e.preventDefault();
    //     $.ajax({
    //       url: '/users/'+$(this).data('id')+'/pods',
    //       data: { pod_id:  $(this).data('pod-id') },
    //       dataType: 'script',
    //       success: function() {
    //         console.log($(this).attr('href'));
    //       }
    //     })
    // })

});