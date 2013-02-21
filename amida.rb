# vim:set fileencoding=utf-8:

require 'pp'

class AmidaLine
  ConnectedSymbol  = '+'
  UnConectedSymbol = '|'

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
    ![self, line].any?{|l|l.connected?(point)}
  end

  def symbol point
    connected?(point) ? ConnectedSymbol : UnConectedSymbol
  end

  def connect_line line, point
    self.connect point
    line.connect point
  end

  protected

  def connect point
    if connected?(point)
      raise "point #{point} is already connected"
    end

    unless points.include?(point)
      raise "point #{point} is invalid position"
    end

    @connections << point
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

    points.each do |p|
      if left_line.connectable?(right_line, p)
        left_line.connect_line(right_line, p)
        return
      end
    end
    raise "not found free point for single connect"
  end

  def random_connect num
    num.times do
      (left_line, right_line) = @lines.each_cons(2).to_a.sample
      point = left_line.points.sample

      if left_line.connectable?(right_line, point)
        left_line.connect_line(right_line, point)
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
