require 'uri'

pages << {
    page_type: 'products_listing',
    method: 'GET',
    url: "https://www.coop.se/handla-online/varor/dryck/energi/energidryck/?st=1",
    vars: {
        'input_type' => 'taxonomy',
        'search_term' => '-',
        'page' => 1
    }


}

search_terms = [
    'Red Bull',
    'RedBull',
    'Energidryck',
    'Energidrycker'
]
search_terms.each do |search_term|

  pages << {

      page_type: 'products_listing',
      method: 'GET',
      url: "https://www.coop.se/handla-online/sok/?q=#{URI.encode(search_term)}&page=1&st=1",
      vars: {
          'input_type' => 'search',
          'search_term' => search_term,
          'page' => 1
      }


  }

end