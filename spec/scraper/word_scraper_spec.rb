require 'spec_helper'
require 'cantonese/scraper/word_scraper'

describe Cantonese::Scraper::WordScraper do
  context "#crawl", :vcr => {:record => :new_episodes} do
    it "should return detail of a word" do
      word = subject.crawl("一")
      expect(word).to be_a(Hash)

      expect(word[:text]).to eq("一")

      expect(word[:stroke]).to eq(1)
      expect(word[:radical_id]).to eq(1)
      expect(word[:classified]).to be_include("單讀音字")

      expect(word[:big5]).to eq("A440")
      expect(word[:chanjie]).to eq("一")
      expect(word[:frequency]).to eq("2 / 166396")
      expect(word[:combination]).to be_a(Array)
      expect(word[:combination]).to be_include("山")

      expect(word[:sounds]).to be_a(Array)
      expect(word[:sounds][0][:initial]).to eq("j")
      expect(word[:sounds][0][:final]).to eq("at")
      expect(word[:sounds][0][:tone]).to eq("1")

      expect(word[:sounds][0][:examples]).to be_a(Array)
      expect(word[:sounds][0][:examples]).to be_include("一視同仁")
    end

    it "should return detail of a word with multiple sounds" do
      word = subject.crawl("可")
      expect(word).to be_a(Hash)

      expect(word[:text]).to eq("可")

      expect(word[:stroke]).to eq(5)
      expect(word[:radical_id]).to eq(30)
      expect(word[:classified]).to eq("破音字")

      expect(word[:big5]).to eq("A569")
      expect(word[:chanjie]).to eq("一弓口")
      expect(word[:frequency]).to eq("36 / 40754")
      expect(word[:combination]).to be_a(Array)
      expect(word[:combination]).to be_include("不")

      expect(word[:sounds]).to be_a(Array)
      expect(word[:sounds][0][:initial]).to eq("h")
      expect(word[:sounds][0][:final]).to eq("ak")
      expect(word[:sounds][0][:tone]).to eq("1")
      expect(word[:sounds][0][:examples]).to be_a(Array)
      expect(word[:sounds][0][:examples]).to be_include("可汗")

      expect(word[:sounds][1][:initial]).to eq("h")
      expect(word[:sounds][1][:final]).to eq("o")
      expect(word[:sounds][1][:tone]).to eq("2")
      expect(word[:sounds][1][:examples]).to be_a(Array)
      expect(word[:sounds][1][:examples]).to be_include("可歌可泣")
    end

  end
end