class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @num_guesses = 0
  end
  
  def lowercase? x
     x != x.downcase
  end
  
  def letter? x
    /[a-z]/i =~ x
  end
  
  def valid? x
    if x == nil || x.empty? || !letter?(x)
      raise ArgumentError
    end
  end
  
  def guess x
    valid?(x)
    
    if lowercase?(x)
      return false  
    end
    
    if @word.include? x
      if !repeated?(x)
        @guesses += x.to_s
        return true
      end
    else
      if !repeated?(x)
        @wrong_guesses += x.to_s
        @num_guesses += 1
        return true
      end
    end
    return false
  end

  def word_with_guesses
    result = ''
    @word.each_char do |x|
      if guesses.include?(x)
        result += x
      else
        result += '-'
      end
    end
    result
  end
  
  def repeated? x
    @guesses.include?(x) || @wrong_guesses.include?(x)
  end
  
  def check_win_or_lose
    if @word.chars.uniq.sort == @guesses.chars.sort
      return :win
    elsif @num_guesses < 7
      return :play
    else
      return :lose
    end
  end
  
  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
