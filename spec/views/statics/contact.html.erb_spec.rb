require "rails_helper"

RSpec.describe "statics/contact.html.erb", type: :view do
  it "has tags" do
    render
    expect(rendered).to have_tag "div", class: "contact"
    expect(rendered).to have_tag "h3", text: "Contact"
  end
end
