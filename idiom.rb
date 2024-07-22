# frozen_string_literal: true

require 'json'

$idioms_list = Set.new

def init_idiom_db
  JSON.parse(File.open("#{__dir__}/chinese-xinhua/data/idiom.json").read).each do |jo|
    $idioms_list.add jo['word']
  end
end

class String

  class << self
    def all_idioms
      $idioms_list
    end
  end
end

