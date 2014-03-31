require 'json'

module Cantonese
  module Scraper
    # get radical from moedict-webkit site
    class RadicalScraper
      def crawl
        json = open("https://raw.githubusercontent.com/audreyt/moedict-webkit/master/c/@.json").read

        result = []
        id = 1
        data = JSON(json)
        data.each_with_index do |radicals, index|
          radicals.each do |radical|
            result << {:name => radical, :stroke => index, :id => id}
            id = id + 1
          end
        end
        result
      end
    end
  end
end