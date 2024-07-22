# frozen_string_literal: true

require 'json'

$words_list = Set.new

def init_word_db
  JSON.parse(File.open("#{__dir__}/chinese-xinhua/data/ci.json").read).each do |jo|
    $words_list.add jo['ci']
  end
end

class String

  class << self
    def all_words
      $words_list
    end
  end
end

