Kaminari.configure do |config|
  config.default_per_page = Settings.default_per_page
  config.page_method_name = :paginer
end
