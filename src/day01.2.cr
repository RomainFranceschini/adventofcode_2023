struct Token
  property string_value : String = ""
  property type : Symbol = :eof

  def initialize(@type, @string_value)
  end
end

class Lexer
  DIGITS = {
    "one" =>  "1",
    "two"=>   "2",
    "three"=> "3",
    "four"=>  "4",
    "five"=>  "5",
    "six"=>   "6",
    "seven"=> "7",
    "eight"=> "8",
    "nine"=>  "9",
  }

  FIRST_CHARS = {'o', 't', 'f', 's', 'e', 'n'}

  @io : IO
  @buffer = IO::Memory.new
  @current_char : Char = '\u0002'

  def initialize(@io)
    next_char
  end

  def each_token(&block : Token ->)
    while !is_at_end
      scan_token(&block)
    end
  end

  def scan_token(&block : Token ->)
    char = @current_char
    case char
    when '\n'
      next_char
      block.call(Token.new(:newline, char.to_s))
    when '0'..'9'
      next_char
      block.call(Token.new(:digit, char.to_s))
    when 'a'..'z'
      consume_identifer(&block)
    end
  end

  def consume_identifer(& : Token ->)
    while is_alpha(@current_char)
      @buffer << @current_char
      next_char
    end

    identifier = @buffer.to_s
    @buffer = IO::Memory.new

    return if identifier.size < 3

    identifier.each_char_with_index do |char, index|
      next unless FIRST_CHARS.includes?(char)
      # start lookahead
      size = Math.min(identifier.size - index, 5)
      next if size < 3

      (1..size).each do |len|
        substr = identifier[index, len]
        if digit = DIGITS[substr]?
          yield Token.new(:digit, digit)
          break
        end
      end
    end
  end

  private def next_char
    @current_char = @io.read_char || '\0'
  end

  private def is_at_end : Bool
    @current_char == '\0'
  end

  private def is_alpha(char : Char) : Bool
    char >= 'a' && char <= 'z'
  end
end

sum = 0
index = 0
values = StaticArray(Int32, 2).new(-1)

Lexer.new(File.open("#{__DIR__}/../input/day01"))
  .each_token do |token|
    case token.type
    when :digit
      values[Math.min(1, index)] = token.string_value.to_i
      index += 1
    when :newline
      values[1] = values[0] unless values.last > 0
      sum += values.first * 10 + values.last
      values[1] = -1
      index = 0
    end
  end

puts sum