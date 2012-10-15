# = Stacked Area
# This example uses the Stack layout to stack areas one over another.
$:.unshift(File.dirname(__FILE__)+"/../../../lib")
require 'rubyvis'

w = 140
h = 160

color = Rubyvis::Colors.category20

y = pv.Scale.linear(0, 4).range(h, 0)

#/* The root panel. */
vis = pv.Panel.new()
    .width(w)
    .height(h)

vis.add(Rubyvis::Layout::Stack)
.layers([[1, 1, 1, 1, 1],
         [1, 1, 1, 1, 1],
         [1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1]])
.x(lambda { index * 35})
.y(lambda {|d| y.scale(d)})
.layer.add(Rubyvis::Area)
.fill (lambda{color.scale(self.parent.index)})
#.fill (lambda{|d| color.scale(d)}) colors the areas in same way if data is equal

vis.render();
f = File.new(File.dirname(__FILE__)+"/fixtures/stacked_fromStackFile.svg", "w")
f.puts vis.to_svg
f.close