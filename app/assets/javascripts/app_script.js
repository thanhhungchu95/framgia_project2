$(document).on('turbolinks:load', function() {
  var title = $(document).attr('title');
  var id = '#active-' + title.substring(0, title.indexOf('|') - 1).toLowerCase();

  $(id).addClass('active');

  $('.alert').delay(2000).slideUp(1500);

  $('input#file-browser').change(function() {
    var reader;
    if (this.files && this.files[0]) {
      reader = new FileReader();
      reader.onload = function(e) {
        $('#image-browser').attr('src', e.target.result);
      };
      reader.readAsDataURL(this.files[0]);
    }
  });
});

$(document).on('turbolinks:load', function() {
  var start_number = 0;

  function gen_new_id(sequence) {
    return 'post_post_tags_attributes_' + sequence + '_tag_attributes_name';
  }

  function gen_new_name(sequence) {
    return '[post[post_tags_attributes][' + sequence + '][tag_attributes][name]';
  }

  function gen_new_hidden_tag(sequence, value) {
    var name = gen_new_name(sequence);
    var id = gen_new_id(sequence);
    return '<input name="' + name + '" id="' + id + '" value="'+ value
      + '" type="hidden">';
  }

  function gen_new_preview_tag(sequence, value) {
    return '<span class="badge badge-default"><span>' + value
      + '</span> <span class="close-tag-btn" id="close-tag-btn-'
      + sequence + '">x</span></span>';
  }

  $('input#tag_input').keyup(function() {
    var input_value = $(this).val();

    if (input_value.substr(-1) == ',') {
      var id_number = start_number++;
      var tag_name = input_value.substr(0, input_value.length - 1);

      $('#tag_param_store').append(gen_new_hidden_tag(id_number, tag_name));
      $('input#tag_input').before(gen_new_preview_tag(id_number, tag_name));
      $(this).val('');

      $('[id^="close-tag-btn-"]').click(function () {
        $(this).parent().remove();
        $('#' + gen_new_id(id_number)).remove();
      });
    }
  });
});
