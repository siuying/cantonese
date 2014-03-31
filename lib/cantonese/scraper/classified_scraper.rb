require 'nokogiri'
require 'open-uri'

module Cantonese
  module Scraper
    class ClassifiedScraper
      def crawl
        html = fetch
        process(html)
      end

      private
      def fetch
        html = open("http://humanum.arts.cuhk.edu.hk/Lexis/lexi-can/classified.php?st=0").read
        html = html.encode('UTF-8', 'Big5', :invalid => :replace, :undef => :replace, :replace => '?')
      end

      def process(html)
        doc  = Nokogiri::HTML(html, nil, 'UTF-8')
        doc.search("//table//tr[position()>1]").collect do |row|
          radical_id = row.xpath(".//td[position()=1]//text()").text.gsub(%r|[\[\]]|, "").to_i
          types = {1 => :'單讀音字', 2 => :'破音字', 3 => :'異讀字', 4 => :'異讀破音字'}
          types.collect do |index, type|
            row.xpath(".//td[position()=#{index}]/a").collect do |link|
              {:radical_id => radical_id, :text => link.text, :type => type}
            end
          end
        end.flatten
      end
    end
  end
end