$(document).on('turbolinks:load', function() {
  var title = $(document).attr('title');
  var id = '#active-' + title.substring(0, title.indexOf('|') - 1).toLowerCase();

  $(id).addClass('active');

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
