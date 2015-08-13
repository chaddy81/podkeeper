$(function() {

    initializeRsvpToggles();
    initializeEventTabs();
    initializeStudentTotalCalculator();
    initializeChangeResponseButton();
    updateStudentCountOnRsvpForm($('.highlight'));
    initializeClickToRsvpLink();
    initializeEventSort();
    initializeUserEventRemindersToggling();
    expandWhosAttending();
    initializeEndTime();

    $('#event_weeks').spinner({
      max: 16,
      min: 2
    });

    // $('#event_description').resizable({ grid: [10000, 1] });

    $('#event_weeks').on('blur', function() {
      if($(this).val() < 2) {
        $(this).val('2');
      }

      if($(this).val() > 16) {
        $(this).val('16');
      }
    });

    console.log($('input[name="event[single_event]"]:checked').val());

    if ($('input[name="event[single_event]"]:checked').val() == 'false') {
      $('#new_event, #edit_event').addClass('weekly-series');
      if($('#event_end_date').val() != '' || $('#event_end_time').val() != '') {
        $('.multiple-event.hide-end').addClass('active');
        $('.single-event.hide-end').removeClass('active');
        $('.multiple-event.show-end').removeClass('active');
        $('.single-event.show-end').removeClass('active');
        $('.end-date-time').show();
      }
    } else {
      $('#new_event, #edit_event').removeClass('weekly-series');
      if($('#event_end_date').val() != '' || $('#event_end_time').val() != '') {
        $('.multiple-event.hide-end').removeClass('active');
        $('.single-event.hide-end').addClass('active');
        $('.multiple-event.show-end').removeClass('active');
        $('.single-event.show-end').removeClass('active');
        $('.end-date-time').show();
      }
    }


    $('#event_single_event_false').on('click', function() {
      $('#new_event, #edit_event').addClass('weekly-series');
      if ($('.single-event.show-end').hasClass('active')) {
        $('.multiple-event.show-end').addClass('active');
        $('.single-event.show-end').removeClass('active');
      }

      if ($('.single-event.hide-end').hasClass('active')) {
        $('.multiple-event.hide-end').addClass('active');
        $('.single-event.hide-end').removeClass('active');
      }
    });

    $('#event_single_event_true').on('click', function() {
      $('#new_event, #edit_event').removeClass('weekly-series');
      if ($('.multiple-event.show-end').hasClass('active')) {
        $('.single-event.show-end').addClass('active');
        $('.multiple-event.show-end').removeClass('active');
      }

      if ($('.multiple-event.hide-end').hasClass('active')) {
        $('.single-event.hide-end').addClass('active');
        $('.multiple-event.hide-end').removeClass('active');
      }
    });

    $('.show-end').on('click', function() {
      $('.end-date-time').show();
      $(this).removeClass('active');
      if($(this).hasClass('multiple-event')) {
        $('.multiple-event.hide-end').addClass('active');
      }else{
        $('.single-event.hide-end').addClass('active');
      }
    });

    $('.hide-end').on('click', function() {
      $('.end-date-time').hide();
      $(this).removeClass('active');
      if($(this).hasClass('multiple-event')) {
        $('.multiple-event.show-end').addClass('active');
      }else{
        $('.single-event.show-end').addClass('active');
      }
    });

    $('.action-bar .create, .controls a:contains("Cancel")').click(function() {
        localStorage.setItem('event-reminder', '');
    });

    $('.event').on('click', '.info__controls', function() {
        $(this).next('ul').slideToggle('fast');
    });

    $('.expand-all').on('click', function(e) {
        e.preventDefault();

        if($(this).text() == 'Expand All') {
            $(this).text('Collapse All');
        }else{
            $(this).text('Expand All');
        }

        $('.info__show-details').click();
    });

    $('.info__show-details').on('touchstart', function() {
        $(this).click();
    });

    $('.specify-reminders a').on('click', function() {
        $('.event-details__reminders').slideToggle('fast');
    });

    // ask user about default time zone
    $('#event_time_zone').change(function() {
        if ($(this).val().indexOf($('#time-zone-modal input#time_zone').val()) < 0) {
            time_zone_name = $('#event_time_zone option:selected').html();
            $('#time-zone-modal .modal-body span').html(time_zone_name);
            $('#time-zone-modal input#time_zone').val($(this).val());
            $('#time-zone-modal').modal();
        }
    });

    $('#time-zone-modal').on('hidden', function() {
        $('#time-zone-modal input#time_zone').val($('#current_user_time_zone').val());
    });

    // $('#event_phone').mask('?999-999-9999');

    // $('#event_start_time').timepicker();

    $('[data-rsvp-reminders] .remove_nested_fields:first').remove();
    $('[data-event-reminders] .remove_nested_fields:first').remove();

    hideShowRsvpReminders();
    $('#event_require_rsvp').change(function() {
        hideShowRsvpReminders();
    });

    hideRsvpRemindersIfMaxIsReached();
    $(document).on('nested:fieldAdded:rsvp_reminders', function(event) {
        hideRsvpRemindersIfMaxIsReached();
    });

    $(document).on('nested:fieldRemoved:rsvp_reminders', function(event) {
        if ($('[data-rsvp-reminders] .input-days:visible').length < 4) {
            $('[data-rsvp-reminders] .add_nested_fields').show();
            $('[data-max-rsvp-reminders]').hide();
        }
    });

    hideEventRemindersIfMaxIsReached();
    $(document).on('nested:fieldAdded:event_reminders', function(event) {
        hideEventRemindersIfMaxIsReached();
    });

    $(document).on('nested:fieldRemoved:event_reminders', function(event) {
        if ($('[data-event-reminders] .input-days:visible').length < 4) {
            $('[data-event-reminders] .add_nested_fields').show();
            $('[data-max-event-reminders]').hide();
        }
    });

});

function expandWhosAttending() {
    $('.details__attending .answer').on('click', function() {
        $(this).toggleClass('open');
        $(this).parent().next('.details__attending-users').toggleClass('open');
    });
}

function hideRsvpRemindersIfMaxIsReached() {
    if ($('[data-rsvp-reminders] .input-days:visible').length >= 4) {
        $('[data-rsvp-reminders] .add_nested_fields').hide();
        $('[data-max-rsvp-reminders]').show();
    }
}

function hideEventRemindersIfMaxIsReached() {
    if ($('[data-event-reminders] .input-days:visible').length >= 4) {
        $('[data-event-reminders] .add_nested_fields').hide();
        $('[data-max-event-reminders]').show();
    }
}

function hideShowRsvpReminders() {
    if ($('#event_require_rsvp').is(':checked')) {
        $('[data-rsvp-reminders]').show();
    } else {
        $('[data-rsvp-reminders]').hide();
    }
}

function initializeUserEventRemindersToggling() {
    if (localStorage.getItem('event-reminder') == 'open') {
        $('.user-event-reminders .headline').addClass('toggle');
        $('#reminder-content').slideToggle();
    }
    $('.user-event-reminders .headline').click(function() {
        $(this).toggleClass('toggle');
        if ($(this).hasClass('toggle')) {
            localStorage.setItem('event-reminder', 'open');
        }else{
            localStorage.setItem('event-reminder', '');
        }
        $('#reminder-content').slideToggle();
        hideRsvpRemindersIfMaxIsReached();
        hideEventRemindersIfMaxIsReached();
        $customReminderInput = $('#event_custom_reminders_specified');
        if ($customReminderInput.val() == 'true') {
            $customReminderInput.val('false')
        } else {
            $customReminderInput.val('true')
        }
    })
}

function initializeEventSort() {
    $('.events-list .sort-header li').click(function() {
        $(this).parents('ul').hide();
        $('ul.events').html('<li style="padding:60px 0 40px; text-align:center;">Loading...</li>');
    });
}

function setEndDateToStartDate() {
    if ($('#event_end_date').val() == '') {
        start_date = $('#event_start_date').val();
        $('#event_end_date').val(start_date);
        $('#event_end_date').datepicker('update');
    }
}

function addEditResponseButtonHandler(event_container_str) {
    event_container_str = event_container_str || '';

    $(event_container_str + ' .edit-response').click(function(e) {
        e.preventDefault();
        $(this).parents('.highlight').find('.answer, .attendees, .controls').fadeToggle('fast');
    });
}

function initializeEventTabs() {
    // Event List tab functionality
    $('.events-list > ul > li').click(function() {
        // if event is not already active
        if(!$(this).is('.active')) {
            $(this).addClass('active');
            $(this).siblings('li').removeClass('active');
            id = $(this).data('event-id');
            $(this).parents('#events').find('.event-details').hide();
            $(this).parents('#events').find('#event-detail-' + id).show();
        }
    });

    // if no event tab is already active, activate the first one
    if ($('.events-list > ul > li.active').length == 0) {
        $('.events-list > ul > li:first').click();
    }
}

function initializeStudentTotalCalculator(selector) {
    selector = selector || '';
    $(selector + ' .highlight input').change(function() {
        $form = $(this).parents('.highlight');
        updateStudentCountOnRsvpForm($form);
    })
}

function updateStudentCountOnRsvpForm(form) {
    num_kids = form.find('#rsvp_number_of_kids').val();
    num_adults = form.find('#rsvp_number_of_adults').val();
    total = parseInt(num_kids) + parseInt(num_adults);
    if (isNaN(total)) {
        total = 'N/A';
    }
    form.find('.details__rsvps__total .total').html('Total: ' + total);
}

function initializeRsvpToggles(selector) {
    selector = selector || '';

    // rsvp comments expand/collapse
    $(selector + ' .comments-toggle').hide();
    $(selector + ' .comments-toggle').click(function(e) {
        e.preventDefault();
        text = $(this).text();
        $(this).text(text == 'Show Quick Comments' ? 'Hide Quick Comments' : 'Show Quick Comments');
        $(this).parent().siblings('.group').find('.comment').slideToggle(50);
    });

    // rsvp section collapse/expanding
    $(selector + ' .group .guests').hide();
    $(selector + ' .group .counter .kids').hide();
    $(selector + ' .group .counter .adults').hide();
    $(selector + ' .whos-going h4').click(function() {
        $(this).toggleClass('toggle');
        $(this).siblings('.counter').find('.kids').slideToggle(50);
        $(this).siblings('.counter').find('.adults').slideToggle(50);
        $(this).siblings('.guests').slideToggle(50, function() {
            if ($('.guests :visible').length > 0) {
                $(this).parent().parent().find('.comments-toggle').show();
                $(selector + ' .collapse-toggle').text('COLLAPSE ALL');
            } else {
                $(this).parent().parent().find('.comments-toggle').hide();
                $(selector + ' .collapse-toggle').text('EXPAND ALL');
            }
        });
    });

    // Expand/Collapse all sections
    $(selector + ' .collapse-toggle').click(function(e) {
        e.preventDefault();
        text = $(this).text();
        if(text == 'EXPAND ALL'){
            $(this).parent().siblings('.group').find('h4').addClass('toggle');
            $(this).parent().siblings('.group').find('.guests').show();
            $(this).parent().parent().find('.comments-toggle').show();
            $(this).text('COLLAPSE ALL');
        }else{
            $(this).parent().siblings('.group').find('h4').removeClass('toggle');
            $(this).parent().siblings('.group').find('.guests').hide();
            $(this).parent().parent().find('.comments-toggle').hide();
            $(this).text('EXPAND ALL');
        }
    });
}

function initializeChangeResponseButton() {
    // edit response button collapse/expanding
    $('.event-details .edit-response').click(function(e) {
        e.preventDefault();
        $(this).parents('.highlight').find('.answer, .attendees, .controls').fadeToggle('fast');
    });
}

function initializeClickToRsvpLink() {
    $('.rsvp-no-response').click(function() {
        id = $(this).parents('li').data('event-id')
        $('#event-detail-' + id).find('.answer, .attendees, .controls').show();
    });
}

function parseTime(timeStr, dt) {
    if (!dt) {
        dt = new Date();
    }

    var time = timeStr.match(/(\d+)(?::(\d\d))?\s*(p?)/i);
    if (!time) {
        return NaN;
    }
    var hours = parseInt(time[1], 10);
    if (hours == 12 && !time[3]) {
        hours = 0;
    }
    else {
        hours += (hours < 12 && time[3]) ? 12 : 0;
    }

    dt.setHours(hours);
    dt.setMinutes(parseInt(time[2], 10) || 0);
    dt.setSeconds(0, 0);
    return dt;
}

function initializeEndTime() {
  $('#event_end_time').on('click', function() {
      var start = $('#event_start_time').val(),
          new_time = new Date(parseTime(start).getTime() + 120*60000),
          hours = new_time.getHours() % 12 || 12,
          minutes = (new_time.getMinutes() < 10 ? '0' : '') + new_time.getMinutes(),
          meridian = new_time.getHours() > 12 ? 'pm':'am',
          end_time = hours + ':' + minutes + meridian;

      // $(this).timepicker({
      //     'setTime': end_time,
      //     'timeFormat': 'g:ia'
      // });
      $(this).val(end_time);
      // $(this).timepicker('hide');
      // $(this).timepicker('show');

      $(".ui-timepicker-list:visible li:contains('" + end_time + "')").addClass('ui-timepicker-selected');
  });

  $('#event_end_time').on('changeTime', function() {
      setEndDateToStartDate();
  });

  $('#event_start_date').datepicker().on('hide', function(e) {
      if ($('#event_end_date').val() == '') {
          $('#event_end_date').val($(this).val());
          $('#event_end_date').datepicker('update');
          $('#event_end_date').val('');
      }
  });

  $('#event_end_date').datepicker().on('click', function(e) {
      if ($('#event_end_date').val() == '') {
          $('#event_end_date').val($('#event_start_date').val());
          $('#event_end_date').datepicker('update');
          $('#event_end_date').val('');
      }
  });
}

function setmax() {
  if ($('#event_weeks').val().length > 2) {
    var input = $('#event_weeks').val().slice(0,2);
    $('#event_weeks').val(input);
  }
}
