# vim:set fileencoding=utf-8:

require 'pp'

class AmidaLine
  ConnectedSymbol  = '+'
  UnConectedSymbol = '|'

  @connections
  @length

  attr_reader :length

  def initialize length
    @length      = length
    @connections = {}
  end

  def points
    (0...@length).to_a
  end

  def connected? point
    @connections.keys.include? point
  end

  def connected_line? line, point
    @connections.keys.include?(point) && @connections[point] == line
  end

  def connectable? line, point
    ![self, line].any?{|l|l.connected?(point)}
  end

  def symbol point
    connected?(point) ? ConnectedSymbol : UnConectedSymbol
  end

  def connect_line line, point
    self.connect line, point
    line.connect self, point
  end

  protected

  def connect line, point
    if connected?(point)
      raise "point #{point} is already connected"
    end

    unless points.include?(point)
      raise "point #{point} is invalid position"
    end

    @connections[point] = line
  end
end

class Amida
  ConnectorWidth  = 3
  ConnectorSymbol = "-"
  SpaceSymbol     = " "

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
      print @lines.first.symbol(point)    # left terminal line

      @lines.each_cons(2) do |left, right|
        # print connector
        if (left.connected_line?(right, point) && right.connected_line?(left, point))
          print ConnectorSymbol * ConnectorWidth
        else
          print SpaceSymbol * ConnectorWidth
        end
        # print symbol
        print right.symbol(point)
      end
        puts
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
