require 'uri'

pages << {
    page_type: 'products_listing',
    method: 'GET',
    url: "https://www.coop.se/handla-online/varor/dryck/energi/energidryck/",
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
  [1, 2].each do |i|
  pages << {

      page_type: 'products_listing',
      method: 'GET',
      url: "https://www.coop.se/handla-online/sok/?q=#{URI.encode(search_term)}&page=#{i}",
      vars: {
          'input_type' => 'search',
          'search_term' => search_term,
          'page' => i
      }


  }
end
end