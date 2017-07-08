$(document).on('turbolinks:load', function() {
  function alert_error(response) {
    if ('error' == response.status) {
      alert(response.message);
    }
  }

  $('.follow-btn').on('click', '.follow', function() {
    var url = $(this).attr('href');
    var relationship_id = url.split('/')[2];
    var follow_text = $(this).attr('data-text');

    $.ajax({
      url: url,
      type: 'DELETE',
      data: {relationship_id: relationship_id},
      dataType: 'json',
      success: function(response) {
        if ('success' == response.status) {
          var link_id = '#follow-btn-' + response.user;

          $(link_id).text(response.text);
          $(link_id).attr('href', '/relationships');
          $(link_id).attr('data-method', 'POST');
          $(link_id).attr('data-id', response.user);
          $(link_id).removeClass('follow').addClass('unfollow');
          $('#followers-count-' + response.user)[0].innerText--;
        }
      },
      error: function(response) {
        alert_error(response);
      }
    });
    return false;
  });

  $('.follow-btn').on('click', '.unfollow', function() {
    $.ajax({
      url: $(this).attr('href'),
      type: 'POST',
      data: {followed_id: $(this).attr('data-id')},
      dataType: 'json',
      success: function(response) {
        if ('success' == response.status) {
          var link_id = '#follow-btn-' + response.user;

          $(link_id).text(response.text);
          $(link_id).attr('href', '/relationships/' + response.relate);
          $(link_id).attr('data-method', 'DELETE');
          $(link_id).attr('data-id', '');
          $(link_id).removeClass('unfollow').addClass('follow');
          $('#followers-count-' + response.user)[0].innerText++;
        }
      },
      error: function(response) {
        alert_error(response);
      }
    });
    return false;
  });
});
