body = Nokogiri.HTML(content)
current_page = page['vars']['page']

unless body.at_css('span.u-colorGray.u-textSmall') && body.search('span.u-colorGray.u-textSmall').first.text == '0 resultat'


  products = body.css('article[itemtype="http://schema.org/Product"]')

  if current_page == 1
    if body.at_css('span.u-colorGray.u-textSmall')
      scrape_url_nbr_products = body.search('span.u-colorGray.u-textSmall').first.text.to_i
    else
      scrape_url_nbr_products = body.css('article[itemtype="http://schema.org/Product"]').size
    end

    scrape_url_nbr_products_pg1 = products.length
  else

    scrape_url_nbr_products = page['vars']['scrape_url_nbr_products']
    scrape_url_nbr_products_pg1 = page['vars']['scrape_url_nbr_products_pg1']
  end

  products.each_with_index do |product, i|

    json = product.at_css('script.js-model').text

    data = JSON.parse(json)


    if data
      id = data['id']
      title = data['name']
      ean_code = data['ean']
      category = 'Energidryck'

      brands = [
          'Red Bull',
          'Nocco',
          'Celsius',
          'Wolverine',
          'Monster',
          'Vitamin Well',
          'Aminopro',
          'Powerade',
          'Nobe',
          'Burn',
          'Njie'
      ]

      brand = 'TEST'
      if data['manufacturer'].include?('**15')
        brands.each do |brand_name|
          if title.include?(brand_name)
            brand = brand_name
            break
          end
        end
      else
        brand = data['manufacturer']
      end


      description = data['details']['description'].gsub(/<("[^"]*"|'[^']*'|[^'">])*>/, '')

      image_url = 'http:' + data['image']['url']
      star_rating = ''
      number_of_reviews = ''
      price = data['price']

      # have no idea
      is_available = '1'

      promotion_text = (data['promos'] || []).map do |promo|
        promo['text']
      end.join('. ')

      item_size = data['details']['size']['size']
      uom = data['details']['size']['unit']

      if title =~ /(\d+)[\s-]?Pack/
        in_pack = $1
      else
        in_pack = '1'
      end

      info = {
          # - - - - - - - - - - -
          RETAILER_ID: '0007',
          RETAILER_NAME: 'coop.se',
          GEOGRAPHY_NAME: 'SE',
          # - - - - - - - - - - -
          SCRAPE_INPUT_TYPE: page['vars']['input_type'],
          SCRAPE_INPUT_SEARCH_TERM: page['vars']['search_term'],
          SCRAPE_INPUT_CATEGORY: page['vars']['input_type'] == 'taxonomy' ? category : '-',
          SCRAPE_URL_NBR_PRODUCTS: scrape_url_nbr_products,
          SCRAPE_URL_NBR_PROD_PG1: scrape_url_nbr_products_pg1,
          PRODUCT_BRAND: brand,
          PRODUCT_RANK: i + 1,
          PRODUCT_PAGE: current_page,
          PRODUCT_ID: id,
          PRODUCT_NAME: title,
          PRODUCT_DESCRIPTION: description,
          PRODUCT_MAIN_IMAGE_URL: image_url,
          PRODUCT_ITEM_SIZE: (item_size rescue ''),
          PRODUCT_ITEM_SIZE_UOM: (uom rescue ''),
          PRODUCT_ITEM_QTY_IN_PACK: (in_pack rescue ''),
          PRODUCT_STAR_RATING: star_rating,
          PRODUCT_NBR_OF_REVIEWS: number_of_reviews,
          SALES_PRICE: price,
          IS_AVAILABLE: is_available,
          PROMOTION_TEXT: promotion_text,
          EXTRACTED_ON: Time.now.to_s,
          EAN: ean_code,
          UPC: ''
      }
      info['_collection'] = 'products'
      outputs << info


    end
  end


# Add  next page
  next_page = body.css('.js-pageNext').attr('href') rescue nil?
  unless next_page.nil?
    
    pages << {
        page_type: 'products_listing',
        method: 'GET',
        url: next_page,
        vars: {
            'input_type' => page['vars']['input_type'],
            'search_term' => page['vars']['search_term'],
            'page' => current_page + 1,
            'scrape_url_nbr_products' => scrape_url_nbr_products,
            'scrape_url_nbr_products_pg1' => scrape_url_nbr_products_pg1
        }


    }

  end

end