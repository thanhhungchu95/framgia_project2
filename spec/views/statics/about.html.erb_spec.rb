require "rails_helper"

RSpec.describe "statics/about.html.erb", type: :view do
  it "has tags" do
    render
    expect(rendered).to have_tag "div", class: "about"
    expect(rendered).to have_tag "h3", text: "About"
  end
end
