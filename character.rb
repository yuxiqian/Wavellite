# frozen_string_literal: true

require 'json'

INITIALS = %w[b p m f d t n l g k h j q x r zh ch sh z c s].freeze
FINALS = %w[ang eng ing ong an en in un er ai ei ui ao ou iu ie ve a o e i u v].freeze

# Handling Hanzi related stuff i guess
$hanzi2pinyin = {}
$pinyin2hanzi = Hash.new { |h, k| h[k] = Set.new }

$hanzi2strokes = {}
$strokes2hanzi = Hash.new { |h, k| h[k] = Set.new }

$simp2trad = {}
$trad2simp = Hash.new { |h, k| h[k] = Set.new }

$hanzi2radicals = {}
$radicals2hanzi = Hash.new { |h, k| h[k] = Set.new }

$radicals = Set.new

def init_hanzi_db(full: false)
  filename = full ? 'pinyin' : 'kTGHZ2013'
  File.readlines("#{__dir__}/pinyin-data/#{filename}.txt")
      .reject { |line| line.start_with? '#' }
      .each do |line|
    code, pinyin, = line.split(/: |#/)
    hanzi = [code[2..].hex].pack('U')
    pinyins = pinyin.split(',').map(&:strip)
    $hanzi2pinyin[hanzi] = pinyins
    pinyins.each { |py| $pinyin2hanzi[py].add(hanzi) }
  end

  JSON.parse(File.open("#{__dir__}/chinese-xinhua/data/word.json").read).each do |jo|
    hanzi = jo['word']
    hanzi_trad = jo['oldword']
    strokes = jo['strokes'].to_i
    radical = jo['radicals']
    $simp2trad[hanzi] = hanzi_trad
    $trad2simp[hanzi_trad].add hanzi
    $hanzi2strokes[hanzi] = strokes
    $strokes2hanzi[strokes].add hanzi
    $hanzi2radicals[hanzi] = radical
    $radicals2hanzi[radical].add hanzi
  end

  $radicals = $radicals2hanzi.keys.to_set
end

def get_accent(input)
  rs = {
    'ā' => 1, 'ō' => 1, 'ē' => 1, 'ī' => 1, 'ū' => 1,
    'á' => 2, 'ó' => 2, 'é' => 2, 'í' => 2, 'ú' => 2,
    'ǎ' => 3, 'ǒ' => 3, 'ě' => 3, 'ǐ' => 3, 'ǔ' => 3,
    'à' => 4, 'ò' => 4, 'è' => 4, 'ì' => 4, 'ù' => 4
  }.filter_map do |k, v|
    v if input.include? k
  end
  rs ? rs.first : 0
end

# Monkey-patch string class. Don't try this at home
class String
  class << self
    def all_hanzi
      $hanzi2pinyin.keys.to_set.filter(&:hanzi?)
    end

    def all_initials
      INITIALS.to_set
    end

    def all_finals
      FINALS.to_set
    end
  end

  def hanzi?
    size == 1 and $hanzi2pinyin.key? self and $hanzi2strokes.key? self and $hanzi2radicals.key? self
  end

  def pinyin?
    $pinyin2hanzi.key? self
  end

  def radical?
    $radicals.key? self
  end

  def radical
    $hanzi2radicals[self]
  end

  def stroke
    $hanzi2strokes[self]
  end

  def traditional
    $simp2trad[self] || self
  end

  def simplified
    $trad2simp[self] || self
  end

  def pinyins
    $hanzi2pinyin[self]
  end

  def hanzi
    $pinyin2hanzi[self]
  end

  def accents
    if hanzi?
      pinyins.map(&:accents)
    elsif pinyin?
      get_accent self
    end
  end

  def remove_accent
    clone.remove_accent!
  end

  def remove_accent!
    {
      'a' => %w[ā á ǎ à],
      'o' => %w[ō ó ǒ ò],
      'e' => %w[ē é ě è],
      'i' => %w[ī í ǐ ì],
      'u' => %w[ū ú ǔ ù]
    }.each do |to, froms|
      froms.each { |from| gsub!(from, to)}
    end
    self
  end

  def with(initial: nil, final: nil)
    if hanzi?
      pinyins.map { |py| py.with(initial: initial, final: final) }
    else
      no_acc = remove_accent
      return false if !initial.nil? && !no_acc.start_with?(initial)
      return false if !final.nil? && !no_acc.end_with?(final)

      true
    end
  end
end
