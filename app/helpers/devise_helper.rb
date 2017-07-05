module DeviseHelper
  def devise_error_messages!
    return "" if errors.empty?

    html = <<-HTML
    <div class="error-explanation">
      <h4>#{sentence}</h4>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  private

  def errors
    resource.errors
  end

  def messages
    errors.full_messages.map{|msg| content_tag :li, msg}.join
  end

  def sentence
    t "errors.messages.not_saved", count: errors.count
  end
end
