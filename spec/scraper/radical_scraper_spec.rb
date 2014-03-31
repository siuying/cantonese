require 'spec_helper'
require 'cantonese/scraper/radical_scraper'

describe Cantonese::Scraper::RadicalScraper do
  context "#crawl", :vcr => {:record => :new_episodes} do
    it "should list of radicals" do
      radicals = subject.crawl
      expect(radicals).to be_a(Array)
      radicals.each do |radical|
        expect(radical[:name]).to_not be_nil
        expect(radical[:stroke]).to_not be_nil
        expect(radical[:id]).to_not be_nil
      end
    end
  end
end