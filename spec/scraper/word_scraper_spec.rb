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

      expect(word[:rank]).to eq(2)
      expect(word[:frequency]).to eq(166396)
      expect(word[:combination]).to be_a(Array)
      expect(word[:combination]).to be_include("山")

      expect(word[:syllable]).to be_a(Array)
      expect(word[:syllable][0][:full]).to eq("jat1")
      expect(word[:syllable][0][:initial]).to eq("j")
      expect(word[:syllable][0][:final]).to eq("at")
      expect(word[:syllable][0][:tone]).to eq("1")

      expect(word[:syllable][0][:examples]).to be_a(Array)
      expect(word[:syllable][0][:examples]).to be_include("一視同仁")
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
      expect(word[:rank]).to eq(36)
      expect(word[:frequency]).to eq(40754)
      expect(word[:combination]).to be_a(Array)
      expect(word[:combination]).to be_include("不")

      expect(word[:syllable]).to be_a(Array)
      expect(word[:syllable][0][:full]).to eq("hak1")
      expect(word[:syllable][0][:initial]).to eq("h")
      expect(word[:syllable][0][:final]).to eq("ak")
      expect(word[:syllable][0][:tone]).to eq("1")
      expect(word[:syllable][0][:examples]).to be_a(Array)
      expect(word[:syllable][0][:examples]).to be_include("可汗")

      expect(word[:syllable][1][:full]).to eq("ho2")
      expect(word[:syllable][1][:initial]).to eq("h")
      expect(word[:syllable][1][:final]).to eq("o")
      expect(word[:syllable][1][:tone]).to eq("2")
      expect(word[:syllable][1][:examples]).to be_a(Array)
      expect(word[:syllable][1][:examples]).to be_include("可歌可泣")
    end

    it "should parse 鏕 properly" do
      word = subject.crawl("鏕")
      expect(word[:syllable]).to be_a(Array)
      expect(word[:syllable][0][:full]).to eq("ou1")
      expect(word[:syllable][1][:full]).to eq("luk6")
    end

    it "should parse 滕 properly" do
      word = subject.crawl("滕")
      expect(word[:text]).to eq("滕")

      expect(word[:stroke]).to eq(15)
      expect(word[:radical_id]).to eq(85)
      expect(word[:classified]).to eq("單讀音字")

      expect(word[:big5]).to eq("BCF0")
      expect(word[:chanjie]).to eq("月火手水")
      expect(word[:rank]).to eq(4410)
      expect(word[:frequency]).to eq(23)
      expect(word[:combination]).to be_a(Array)

      expect(word[:syllable]).to be_a(Array)
      expect(word[:syllable][0][:full]).to eq("tang4")
      expect(word[:syllable][0][:note]).to eq("(1)姓氏 (2)周代國名")
    end


    it "should parse 不 properly" do
      word = subject.crawl("不")
      expect(word[:text]).to eq("不")

      expect(word[:stroke]).to eq(4)
      expect(word[:radical_id]).to eq(1)
      expect(word[:classified]).to eq("破音字")

      expect(word[:big5]).to eq("A4A3")
      expect(word[:chanjie]).to eq("一火")
      expect(word[:rank]).to eq(5)
      expect(word[:frequency]).to eq(107418)
      expect(word[:combination]).to be_a(Array)
      expect(word[:combination]).to be_include("一")
      expect(word[:combination]).to be_include("躞")
      expect(word[:combination]).to_not be_include("筆")

      expect(word[:syllable]).to be_a(Array)
      expect(word[:syllable][0][:full]).to eq("bat1")
      expect(word[:syllable][1][:full]).to eq("fau2")
      expect(word[:syllable][1][:note]).to eq("同「否」字")
    end
  end
end