# = Inheritance and labels
# Second example of Protovis "Getting Started section"
# The rule's label inherits the data and bottom property, causing it to appear on the rule and render the value (datum) as text. The bar’s label uses the bottom anchor to tweak positioning, so that the label is centered at the bottom of the bar. 
$:.unshift(File.dirname(__FILE__)+"/../../lib")
require 'rubyvis'

h = 200
w = 150

vis = pv.Panel.new()
.width(w)
.height(h)
.font_size("10px")
.font_family("sans-serif")

vis.add(pv.Rule).
  data(pv.range(0, 2, 0.5)).
  x1(0).
  x2(150).
  y1(lambda {|d| h - d * 80 - 0.5}).
  y2(lambda {|d| h - d * 80 - 0.5}).
  shape_rendering("crispEdges").
  stroke("rgb(0,0,0)").
  add(pv.Label).
  x(3).
  y(lambda {|d| h - d * 80 - 3.5})


vis.add(pv.Bar).
  data([1, 1.2, 1.7, 1.5, 0.7]).
  width(20).height(lambda {|d|  d * 80}).
  x(lambda { index * 25 + 25}).
  y(lambda {|d| h - d * 80}).
  fill("rgb(31,119,180)").
    add(pv.Label).
    x{(index + 1) * 25 + 10}.
    y(h - 3).
    fill("rgb(0,0,0)").
    text_anchor("middle")


vis.render();
f = File.new(File.dirname(__FILE__)+"/fixtures/2_bar_and_rule.svg", "w")
f.puts vis.to_svg
f.close

