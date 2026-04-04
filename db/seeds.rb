require 'httparty'
require 'nokogiri'

AdminUser.create!(email: 'admin@fpvshop.com', password: 'fpvworldrules!', password_confirmation: 'fpvworldrules!') if Rails.env.development?


# todo: add function to clear the image file because it might pile up? or not, I don't kknow.



# 5.times do
#   Category.create!(
#     name: Faker::Commerce.unique.department(max: 1)
#   )
# end


# 100.times do
#   Product.create!(
#     name: Faker::Commerce.product_name,
#     brand: Faker::Company.name,
#     description: Faker::Lorem.paragraph,
#     price: Faker::Commerce.price(range: 10..300),
#     sku: Faker::Alphanumeric.alphanumeric(number: 8).upcase,
#     stock: Faker::Number.between(from: 5, to: 50),
#     category: Category.all.sample,
#     image_url: "test/BikeYo.jpg"
#   )
# end



require 'httparty'
require 'nokogiri'
require 'open-uri'
require 'fileutils'

BASE_URL = 'https://epicfpv.ca'
IMAGE_DIR = Rails.root.join('public', 'images', 'products')

# ----------------------------------------------------------------------
# Helper methods
# ----------------------------------------------------------------------

# downlaod image
def download_image(image_url, product_name)
  return nil unless image_url.present?

  # create directory
  FileUtils.mkdir_p(IMAGE_DIR)

  # generate file name
  filename = "#{product_name.parameterize}.jpg"
  local_path = IMAGE_DIR.join(filename)

  # if image exists, reuse.
  return "/images/products/#{filename}" if File.exist?(local_path)

  begin
    puts "      Downloading image for #{product_name}..."
    URI.open(image_url) do |image|
      File.open(local_path, 'wb') do |file|
        file.write(image.read)
      end
    end
    puts "      Image saved as #{filename}"
    "/images/products/#{filename}"
  rescue => e
    puts "      Failed to download image: #{e.message}"
    nil
  end
end

# collection data
def fetch_category_urls
  puts "Fetching category URLs from #{BASE_URL}..."
  response = HTTParty.get(BASE_URL)
  doc = Nokogiri::HTML(response.body)


  category_links = doc.css('.main-nav__item.child-nav__item').map do |a|
    href = a['href']
    next unless href && href.start_with?('/collections/')
    "#{BASE_URL}#{href}"
  end.compact

  category_links.uniq
end

# fetch product data
def fetch_product_links_from_category(category_url)
  puts "  Scraping category: #{category_url}"
  response = HTTParty.get(category_url)
  doc = Nokogiri::HTML(response.body)


  product_links = doc.css('a.card-link.js-prod-link').map do |a|
    href = a['href']
    next unless href
    href.start_with?('http') ? href : "#{BASE_URL}#{href}"
  end.compact

  product_links.uniq
end

# Srap single product data.
def scrape_product(product_url)
  puts "    Scraping product: #{product_url}"
  response = HTTParty.get(product_url)
  doc = Nokogiri::HTML(response.body)

  name = doc.at_css('h1.product-title')&.text&.strip


  price_text = doc.at_css('.price__current')&.text
  price = price_text ? price_text.gsub(/[^0-9\.]/, '').to_f : nil


  brand = doc.at_css('.product-vendor a')&.text&.strip


  sku = doc.at_css('.product-sku__value')&.text&.strip


  id_text = doc.at_css('.product-location-id')&.text
  custom_id = id_text&.gsub(/ID:/, '')&.strip if id_text

  #
  img = doc.at_css('.media-viewer__item img')
  image_url = nil
  if img
    image_url = img['data-src'] || img['src']

    if image_url && image_url.start_with?('//')
      image_url = "https:#{image_url}"
    end
  end

  # description
  # Iinspect product image
  description = doc.at_css('.product-description')&.text&.strip

  # download image
  local_image_path = nil
  if name && image_url
    local_image_path = download_image(image_url, name)
  end

  {
    name: name,
    price: price,
    brand: brand,
    sku: sku,
    custom_id: custom_id,
    image_url: local_image_path,
    description: description,
    url: product_url
  }
rescue => e
  puts "    Error scraping #{product_url}: #{e.message}"
  nil
end









# seeding

puts "Starting seeding from epicfpv.ca..."


# Product.destroy_all

categories = fetch_category_urls

categories.each do |cat_url|
  product_links = fetch_product_links_from_category(cat_url)

  product_links.each do |prod_url|
    product_data = scrape_product(prod_url)
    next unless product_data && product_data[:name]

    # Category
    cat_name = cat_url.split('/collections/').last.split('?').first
    cat_name = cat_name.gsub('-', ' ').titleize
    category = Category.find_or_create_by(name: cat_name)

    # SKu identifier
    product = if product_data[:sku].present?
                Product.find_or_initialize_by(sku: product_data[:sku])
    else
                Product.find_or_initialize_by(name: product_data[:name])
    end

    product.assign_attributes(
      name: product_data[:name],
      brand: product_data[:brand],
      description: product_data[:description],
      price: product_data[:price],
      sku: product_data[:sku],
      stock: rand(5..150),
      category: category,
      image_url: product_data[:image_url]
    )

    if product.save
      puts "    Saved: #{product.name}"
    else
      puts "    Failed to save #{product.name}: #{product.errors.full_messages}"
    end

    # one second in between
    sleep 1
  end
end

puts "Seeding complete!"
