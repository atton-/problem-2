# vim:set fileencoding=utf-8:

class AmidaLine
  @connections
  @length

  def initialize length
    @connections = []
    @length      = length
  end

  def connected? point
    @connections.include? point
  end

  def connect point
    if connected?(point)
      raise "point #{point} is already connected"
    end

    unless (0...@length).include?(point)
      raise "point #{point} is invalid position"
    end

    @connections << point
  end
end

hoge = AmidaLine.new(19)
p hoge.connected?(3)
p hoge.connect(3)
p hoge.connect(3)
p hoge.connected?(3)
p hoge.connect(18)
p hoge.connect(39)

class Amida
  @lines

  def initialize num, length=10
    @lines = []
    num.times{@lines << AmidaLine.new(length)}
  end

  def display
    print "hoge"
  end
end


amida = Amida.new(2)
amida.display
