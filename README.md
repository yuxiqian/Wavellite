# Wavellite

## 拼音

```ruby
# 这是合法的拼音吗
'zhū'.pinyin? # => true
'xín'.pinyin? # => false

# 拼音反查汉字
'ě'.hanzi # => {'恶'}
'xīn'.hanzi # => {"䜣", "心", "忻", "新", "昕", "欣", "歆", "炘", "芯", "莘", "薪", "辛", "鑫", "锌", "馨", "𫷷"}

```

## 汉字

```ruby
# 获取全部汉字
String.all_hanzi.size # => 7418

# 这是个汉字吗
'你'.hanzi? # => true
'Hello'.hanzi? # => false

# 获取汉字拼音
'你'.pinyin # => ["nǐ"]
'好'.pinyin # => ["hǎo", "hào"]

# 获取汉字声调
'你'.accent # => [3]
'好'.accent # => [3, 4]

# 是否押韵
'你'.with(final: 'i') # => [true]
'我'.with(final: 'u') # => [false]

# 查询汉字笔画
'春城无处不飞花'.each_char.map(&:strokes) # => [9, 9, 4, 5, 4, 3, 7]
String.all_hanzi.filter { |zi| zi.strokes == 26 } # => ["蠼"]

# 查询汉字部首
'烟锁池塘柳'.each_char.map(&:radical) # => ["火", "钅", "氵", "土", "木"]
String.all_hanzi.filter { |zi| zi.strokes == 24 && zi.radical == '金' } # => ["鑫"]

# 简繁转换
'忧'.traditional # => "憂"
'懼'.simplified # => {"惧"}
```

## 词语和成语

```ruby
# 获取全部词语
String.all_words.size # => 264374
String.all_words.first # => "宸纶"

# 获取全部成语
String.all_idioms.size # => 30895
String.all_idioms.first # => "阿鼻地狱"

# 组合起来
String
    .all_idioms
    .filter { |idiom| idiom.size == 4 }
    .filter { |idiom| idiom.each_char.map(&:accent).flatten == [1, 2, 3, 4] }
    .filter { |idiom| %w[金 木 水 火 土].include? idiom[0].radical }
    .filter { |idiom| idiom[1].pinyin.first.with(initial: 'h') }
    .filter { |idiom| idiom[2].pinyin.first.with(final: 'i') }
    .filter { |idiom| idiom[3].strokes > 20 }
# => ["析骸以爨"]
```
