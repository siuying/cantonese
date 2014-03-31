require 'nokogiri'
require 'open-uri'
require 'cgi'

module Cantonese
  module Scraper
    class WordScraper
      def crawl(word)
        html = fetch(word)
        process(html)
      end

      def fetch(word)
        # convert word parameter into big5
        word_big5 = word.encode('Big5', 'UTF-8', :invalid => :replace, :undef => :replace, :replace => '')
        url = "http://humanum.arts.cuhk.edu.hk/Lexis/lexi-can/search.php?q=" + CGI.escape(word_big5)

        # fetch and get the page in UTF8
        html = open(url).read
        html = html.encode('UTF-8', 'Big5', :invalid => :replace, :undef => :replace, :replace => '?')
      end

      def process(html)
        doc  = Nokogiri::HTML(html, nil, 'UTF-8')
        
        word = doc.search(".w").first.text

        radical_id  = doc.search("//*[@class = 't' and .='部首:']/following-sibling::td[1]").text.strip.tr('[] ', '').to_i rescue nil
        stroke      = doc.search("//*[@class = 't' and .='筆畫:']/following-sibling::td[1]").text.to_i rescue nil
        classified  = doc.search("//*[@class = 't' and .='字音分類:']/following-sibling::td[1]").text rescue nil
        big5        = doc.search("//*[@class = 't' and .='大五碼:']/following-sibling::td[1]").text rescue nil
        chanjie     = doc.search("//*[@class = 't' and .='倉頡碼:']/following-sibling::td[1]").text rescue nil
        frequency   = doc.search("//*[@class = 't' and .='頻序 / 頻次:']/following-sibling::td[1]").text rescue nil
        combination = doc.search("//text()[.='配搭點:']/following-sibling::a").collect{|a| a.text}

        sounds      = doc.search('//form/table[1]/tr[position()>1]').collect do |row|
          sound = row.search("./td[1]")
          initial = sound.xpath("./*[@color='red']").text rescue nil
          final = sound.xpath("./*[@color='green']").text rescue nil
          tone = sound.xpath("./*[@color='blue']").text rescue nil
          sound_text = sound.text
          pronunciation = "http://humanum.arts.cuhk.edu.hk/Lexis/lexi-can/sound/#{sound_text}.wav"

          example_or_note = row.search("./td[6]")
          note = example_or_note.xpath("./*[@color='forestgreen']")
          if note.size > 0
            example_text = nil
            note_text = note.text
          else
            example_text = example_or_note.text.gsub(%r{\[[0-9]+\.\.\]}, ', ').split(", ")
            note_text = nil
          end

          {
            :syllable => {
              :initial => initial, 
              :final => final, 
              :tone => tone
            },
            :pronunciation => pronunciation,
            :examples => example_text,
            :note => note_text
          }
        end

        {
          :text => word, 
          :radical_id => radical_id, 
          :stroke => stroke,
          :classified => classified,
          :big5 => big5,
          :chanjie => chanjie,
          :frequency => frequency,
          :sounds => sounds,
          :combination => combination
        }
      end
    end
  end
end