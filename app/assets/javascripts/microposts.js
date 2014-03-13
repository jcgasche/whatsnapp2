function updateCountdown() {
    // 200 is the max message length
    var remaining = 200 - jQuery('#micropost[content]').val().length;
    jQuery('.countdown').text(remaining + ' characters remaining');
}

jQuery(document).ready(function($) {
    updateCountdown();
    $('#micropost[content]').change(updateCountdown);
    $('#micropost[content]').keyup(updateCountdown);
});