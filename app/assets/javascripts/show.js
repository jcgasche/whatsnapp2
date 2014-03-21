



 


$(document).ready(function() {

  $("#input_to_be_loaded").keydown(function (event) {

    if (event.which == 13) {

      event.preventDefault();

      var $form = $("#message-form"),
      $submit = $form.find('button[type="submit"]'),
      message_value = $form.find('input[name="micropost[content]"]').val(),
      recipient_value = $form.find('input[name="recipient[recipient_id]"]').val(),
      url = '/microposts';

      /* Send the data using post */

      $.post(url, {
        micropost: {
          recipient_id: recipient_value,
          content: message_value
        },
        recipient_id: recipient_value,
        content: message_value
      });
      $('#input_to_be_loaded').css('background-color','#f00');

      $('#input_to_be_loaded').html("");
    }

  });

});
