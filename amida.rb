# vim:set fileencoding=utf-8:

require 'pp'

class AmidaLine
  ConnectedSymbol  = '|'

  UnConectedSymbol = '+'

  @connections
  @length

  attr_reader :length

  def initialize length
    @connections = []
    @length      = length
  end

  def points
    (0...@length).to_a
  end

  def connected? point
    @connections.include? point
  end

  def connectable? line, point
    ![self, line].any?{|l| l.connected?(point)}
  end

  def connect point
    if connected?(point)
      raise "point #{point} is already connected"
    end

    unless points.include?(point)
      raise "point #{point} is invalid position"
    end

    @connections << point
  end

  def symbol point
    return ConnectedSymbol if connected? point
    UnConectedSymbol
  end
end

class Amida
  SpaceNum    = 3
  SpaceSymbol = " "

  @lines

  def initialize num, line_length=10, random_lines=5
    @lines = []
    num.times{@lines << AmidaLine.new(line_length)}
    single_connect
    random_connect random_lines
  end

  def single_connect
    @lines.each_cons(2) do |left, right|
      try_connect left, right
    end
  end

  def try_connect left_line, right_line
    points = left_line.points
    points.shuffle!

    lines = [left_line, right_line]

    points.each do |p|
      if left_line.connectable?(right_line, p)
        left_line.connect(p)
        right_line.connect(p)
        return
      end
    end
    raise "not found free point for single connect"
  end

  def random_connect num
    num.times do
      lines = @lines.sample(2)
      point = lines.first.points.sample
      if lines.first.connectable?(lines.last, point)
        lines.first.connect point
        lines.last.connect  point
      end
    end
  end

  def display
    @lines.first.points.each do |point|

      puts @lines.map{|l|l.symbol(point)}.join(SpaceSymbol * SpaceNum)
    end
  end
end


Amida.new(9,5).display
puts
Amida.new(8,2).display
puts
Amida.new(8,1).display
puts

amida = Amida.new(10)
amida.display
