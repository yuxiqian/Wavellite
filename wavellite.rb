# frozen_string_literal: true

require_relative 'character'
require_relative 'word'
require_relative 'idiom'

init_hanzi_db
init_word_db
init_idiom_db

# 获取全部汉字
p String.all_hanzi.size # => 7418

# 这是个汉字吗
p '你'.hanzi? # => true
p 'Hello'.hanzi? # => false

# 获取汉字拼音
p '你'.pinyins # => ["nǐ"]
p '好'.pinyins # => ["hǎo", "hào"]

# 获取汉字声调
p '你'.accents # => [3]
p '好'.accents # => [3, 4]

# 这是合法的拼音吗
p 'zhū'.pinyin? # => true
p 'xín'.pinyin? # => false

# 拼音反查汉字
p 'ě'.hanzi # => {'恶'}
p 'xīn'.hanzi # => {"䜣", "心", "忻", "新", "昕", "欣", "歆", "炘", "芯", "莘", "薪", "辛", "鑫", "锌", "馨", "𫷷"}

# 是否押韵
p '你'.with(final: 'i') # => [true]
p '我'.with(final: 'u') # => [false]

# 查询汉字笔画
p '春城无处不飞花'.each_char.map(&:stroke) # => [9, 9, 4, 5, 4, 3, 7]
p(String.all_hanzi.filter { |zi| zi.stroke == 26 }) # => ["蠼"]

# 查询汉字部首
p '烟锁池塘柳'.each_char.map(&:radical) # => ["火", "钅", "氵", "土", "木"]
p(String.all_hanzi.filter { |zi| zi.stroke == 24 && zi.radical == '金' }) # => ["鑫"]

# 简繁转换
p '忧'.traditional # => "憂"
p '懼'.simplified # => {"惧"}

# 获取全部词语
p String.all_words.size # => 264374
p String.all_words.first # => "宸纶"

# 获取全部成语
p String.all_idioms.size # => 30895
p String.all_idioms.first # => "阿鼻地狱"

# 组合起来
p(String
    .all_idioms
    .filter { |idiom| idiom.size == 4 }
    .filter { |idiom| idiom.each_char.map(&:accents).flatten == [1, 2, 3, 4] }
    .filter { |idiom| %w[钅 木 氵 火 土].include? idiom[0].radical }
    .filter { |idiom| idiom[1].pinyins.first.with(initial: 'h') }
    .filter { |idiom| idiom[2].pinyins.first.with(final: 'i') }
    .filter { |idiom| idiom[3].stroke > 20 }
) # => ["析骸以爨"]
