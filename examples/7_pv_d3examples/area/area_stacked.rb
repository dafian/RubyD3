# = Stacked Area
# This example uses the Stack layout to stack areas one over another.
$:.unshift(File.dirname(__FILE__)+"/../../../lib")
require 'rubyvis'

data = pv.range(4).map {|i|
  pv.range(0, 10, 0.1).map {|x|
    OpenStruct.new({:x=> x, :y=> Math.sin(x) + rand() * 0.5 + 2})
  }
}

w = 400
h = 200
l = 20
b = 20
r = 10
t = 5

x = pv.Scale.linear(0, 9.9).range(0, w)
y = pv.Scale.linear(0, 14).range(h, 0)

#/* The root panel. */
vis = pv.Panel.new() do

  width w + r + l
  height h + b + t
  fill "none"
  font_family "sans-serif"
  font_size "10px"
  stroke "none"
  stroke_width "1.5"

  group do
    transform "translate(" + l.to_s + "," + t.to_s + ")"

    rule do
      data(x.ticks())
      visible(lambda {|d| d!=0})
      x1 x
      x2 x
      y1 h
      y2 h + t
      shape_rendering "crispEdges"
      stroke_width "1"
      stroke "rgb(0,0,0)"
    end
  end

  group do
    transform "translate(" + l.to_s + "," + t.to_s + ")"

    label do
      data(x.ticks())
      dy ".71em"
      fill "rgb(0,0,0)"
      text_anchor "middle"
      x x
      y h + t
      text(x.tick_format)
    end
  end

  group do
    transform "translate(" + l.to_s + "," + t.to_s + ")"

    rule do
      data(y.ticks(3))
      shape_rendering "crispEdges"
      stroke(lambda {|d|  d!=0 ? "rgba(128,128,128,.2)" : "#000"})
      stroke_width "1"
      stroke_opacity{|d| d!=0 ? "0.2" : nil}
      x1 0
      x2 w
      y1 y
      y2 y
    end
  end

  group do
    transform "translate(" + l.to_s + "," + t.to_s + ")"

    label do
      data(y.ticks(3))
      dy ".35em"
      fill "rgb(0,0,0)"
      text_anchor "end"
      x 3 * -1
      y y
      text(y.tick_format)
    end
  end

  group do
    transform "translate(" + l.to_s + "," + t.to_s + ")"

    #/* The stack layout. */
    add (pv.Layout.Stack) do
      layers(data)
      x(lambda {|d| x.scale(d.x)})
      y(lambda {|d| y.scale(d.y)})
      layer.add(pv.Area)
    end
  end

end



vis.render()
f = File.new('C:\Users\Andrea\Desktop\SVGhw\stacked_charts.svg', "w")
f.puts vis.to_svg
f.close