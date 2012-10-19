# = Line Chart
# This line chart is constructed a Line mark.
# The second line, inside the first one, is created using an anchor.
$:.unshift(File.dirname(__FILE__)+"/../../lib")
require 'rubyvis'

data = pv.range(0, 10, 0.1).map {|x| 
  OpenStruct.new({:x=> x, :y=> Math.sin(x) + 2}) #+rand()
}

#p data
w = 430
h = 225
x = pv.Scale.linear(data, lambda {|d| d.x}).range(0, w - 30)
y = pv.Scale.linear(data, lambda {|d| d.y}).range(h - 25, 0);

#/* The root panel. */
vis = pv.Panel.new() do
  width(w)
  height(h)
  fill "none"

  group do
    transform "translate(20,5)"

    line do
      data(data).
      stroke_width(5).
      x(lambda {|d| x.scale(d.x)}).
      y(lambda {|d| y.scale(d.y)}).
      stroke("rgb(31,119,180)").
      add(pv.Line).
      x(lambda {|d| x.scale(d.x)}).
      y(lambda {|d| y.scale(d.y)}).
      stroke('red').
      stroke_width(1)
    end
  end
end

vis.render();

f = File.new(File.dirname(__FILE__)+"/fixtures/line.svg", "w")
f.puts vis.to_svg
f.close
