require 'spec_helper'
require 'cantonese/scraper/classified_scraper'

describe Cantonese::Scraper::ClassifiedScraper do
  context "#crawl", :vcr => {:record => :new_episodes} do
    it "should fetch list of classified words" do
      classified = subject.crawl
      expect(classified).to be_a(Array)

      classified.each do |word|
        expect(word[:radical_id]).to_not be_nil
        expect(word[:text]).to_not be_nil
        expect(word[:text].length).to eq(1)
        expect(word[:type]).to_not be_nil
      end
    end
  end
end