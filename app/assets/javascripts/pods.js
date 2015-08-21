$(function() {
    $('.pod-details__delete').on('click', function(e) {
        $('.pod-details__delete-details').slideToggle();
    });

    // pod header hiding/showing
    $('section.info .description .more-info').click(function(e){
        e.preventDefault();
        $(this).siblings('.full-desc').slideToggle('fast');
        $(this).toggleClass('switch');
        text = $(this).text() == 'More Info' ? 'Less Info' : 'More Info';
        $(this).text(text);
    });

    // pod sub category hiding/showing
    hideShowPodSubCategory();
    addPodSubCategoryEventHandler();
    $('#set_user_time_zone').set_timezone( { 'default' : 'America/Los_Angeles' } );
    $('#pod_user_pod_category_id').change(hideShowPodSubCategory);

    $('[data-delete-pod]').hide();

    $('[data-show-delete-pod-info]').click(function() {
        $('[data-delete-pod]').show();
    });

    // hide sort header if no notes present
    if ($('.board .desc').length === 0) {
        $('.sort-header-notes').hide();
    }

    // Marketing Messages
    selector = '.marketing-message';
    current = $(selector + ' li.active').index();
    total = $(selector + ' ul li').size();

    $(selector + ' .nav .current').text(current + 1);
    $(selector + ' .nav .total').text(total);

    $('.nav .next').click(function(e) {
        current = $(selector + ' li.active').index();

        if ((current + 1) > $(selector + ' ul li:last-child').index()) {
            $(selector + ' li.active').removeClass('active');
            $(selector + ' ul li').eq(0).addClass('active');
            $(selector + ' .nav .current').text($(selector + ' li.active').index() + 1);
        } else {
            $(selector + ' li.active').removeClass('active');
            $(selector + ' ul li').eq(current + 1).addClass('active');
            $(selector + ' .nav .current').text($(selector + ' li.active').index() + 1);
        }
    });

    $('.nav .previous').click(function(e) {
        current = $(selector + ' li.active').index();

        if ((current - 1) < $(selector + ' ul li:first-child').index()) {
            $(selector + ' li.active').removeClass('active');
            $(selector + ' ul li:last-child').addClass('active');
            $(selector + ' .nav .current').text($(selector + ' li.active').index() + 1);
        } else {
            $(selector + ' li.active').removeClass('active');
            $(selector + ' ul li').eq(current - 1).addClass('active');
            $(selector + ' .nav .current').text($(selector + ' li.active').index() + 1);
        }
    });
});

function addPodSubCategoryEventHandler()
{
    $('.create-pod__category').change(function() {
        pod_category_text = $('.create-pod__category option:selected').text();
        $pod_sub_category_input = $('.create-pod__sub-category').parents('.form-group');
        if (pod_category_text == 'Arts/Music' ||
            pod_category_text == 'Sports'  ||
            pod_category_text == 'Parents Activity') {
            populatePodSubCategory($(this).val());
        } else {
            $pod_sub_category_input.hide();
        }
    });
}

function hideShowPodSubCategory()
{
    $('.create-pod__sub-category').parents('.form-group').hide();
    pod_category_text = $('#pod_pod_category_id option:selected').text();
    if (pod_category_text == 'Arts/Music' ||
        pod_category_text == 'Sports'  ||
        pod_category_text == 'Parents Activity') {
        populatePodSubCategory($('#pod_pod_category_id option:selected').val());
        $('.create-pod__sub-category').parents('.form-group').show();
    }
    console.log($('#pod_pod_category_id option:selected').val());
}

function populatePodSubCategory(category_id) {
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url:  '/pods/update_pod_sub_category/' + category_id,
        success: function(data) {
            var $select = $('.create-pod__sub-category');
            $select_val = $select.val();
            $select.empty();
            $select.append($('<option value>--Select--</option>'));
            $.each(data, function(key, sub_category) {
                $select.append($('<option></option>').attr('value', sub_category.id).text(sub_category.display_name));
            });
            $select.parents('.form-group').show();
            $select.val($select_val);
        }
    });
}
