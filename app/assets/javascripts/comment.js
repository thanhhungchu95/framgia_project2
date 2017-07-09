$(document).on('turbolinks:load', function() {
  function gen_new_edit_form(content, update_label, cancel_label) {
    return '<textarea class="edit-comment-input form-control">' + content
      + '</textarea><a class="submit-update" href="#">' + update_label
      + '</a><a class="cancel-update" href="#">' + cancel_label + '</a>';
  }

  function alert_error(response) {
    if ('error' == response.status) {
      alert(response.message);
    }
  }

  $('#comment-toggle').click(function() {
    $('#comment').fadeToggle(500);
  });

  $('#new_comment').submit(function() {
    $.ajax({
      url: $(this).attr('action'),
      type: 'POST',
      data: $(this).serialize(),
      dataType: 'json',
      success: function(response) {
        if('success' == response.status) {
          $('#comment-list').append(response.html);
          $('#comment-field').val('');
          $('#comment-list').scrollTop($('#comment-list')[0].scrollHeight);
          $('#comment-toggle').children('span.badge')[0].innerText++;
        }
      },
      error: function(response) {
        alert_error(response);
      }
    });
    return false;
  });

  $('#comment-list').on('click', '.delete-comment', function() {
    var url_attr = $(this).attr('href').split('/');
    var post_id = url_attr[2];
    var comment_id = url_attr[4];
    var id = '#comment-' + post_id + '-' + comment_id;
    var confirm_delete = confirm($(this).attr('data-sure'));

    if (confirm_delete == true) {
      $.ajax({
        url: $(this).attr('href'),
        type: 'DELETE',
        data: {id: comment_id, post_id: post_id},
        dataType: 'json',
        success: function(response) {
          if ('success' == response.status) {
            $(id).remove();
            $('#comment-toggle').children('span.badge')[0].innerText--;
          }
        },
        error: function(response) {
          alert_error(response);
        }
      });
    }
    return false;
  });

  $('#comment-list').on('click', '.edit-comment', function() {
    var url_attr = $(this).attr('href').split('/');
    var post_id = url_attr[2];
    var comment_id = url_attr[4];
    var id = '#content-' + post_id + '-' + comment_id;
    var action_id = '#comment-action-' + post_id + '-' + comment_id;
    var content = $(id).children('p')[0].innerText;
    var update_btn_label = $(this).attr('data-update');
    var cancel_btn_label = $(this).attr('data-cancel');

    $(id).children('p:first').replaceWith(gen_new_edit_form(content,
      update_btn_label, cancel_btn_label));
    $(action_id).hide();
    return false;
  });

  $('#comment-list').on('click', '.cancel-update', function() {
    var edit_field = $(this).prev().prev()[0];
    var previous_comment_element = '<p>' + edit_field.defaultValue + '</p>';

    $(this).prev().prev().replaceWith(previous_comment_element);
    $(this).parent().next().show();
    $(this).prev().remove();
    $(this).remove();
    return false;
  });

  $('#comment-list').on('click', '.submit-update', function() {
    var id_attr = $(this).parent().attr('id').split('-').slice(1);
    var post_id = id_attr[0];
    var comment_id = id_attr[1];
    var content = $(this).prev().val();

    $.ajax({
      url: '/posts/' + post_id + '/comments/' + comment_id,
      type: 'PUT',
      data: {id: comment_id, post_id: post_id, content: content},
      dataType: 'json',
      success: function(response) {
        if('success' == response.status) {
          var targetID = '#comment-' + post_id + '-' + comment_id;
          $(targetID).replaceWith(response.html);
        }
      },
      error: function(response) {
        alert_error(response);
      }
    });
    return false;
  });
});
