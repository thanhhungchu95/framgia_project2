Kaminari.configure do |config|
  config.default_per_page = Settings.kaminari.default_per_page
  config.max_per_page = Settings.kaminari.max_per_page
  config.page_method_name = :paginer
end
