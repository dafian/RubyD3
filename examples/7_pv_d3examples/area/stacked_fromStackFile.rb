# = Stacked Area
# This example uses the Stack layout to stack areas one over another.
$:.unshift(File.dirname(__FILE__)+"/../../../lib")
require 'rubyvis'

w = 140
h = 200
color = Rubyvis::Colors.category20

#/* The root panel. */
vis = pv.Panel.new()
    .width(w)
    .height(h)

vis.add(Rubyvis::Layout::Stack)
.layers([[1.1, 1, 1, 1, 1],
         [1, 1, 1, 1, 1],
         [1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1]])
.x(lambda { index * 35})
.y(lambda {|d| d * 40})
.layer.add(Rubyvis::Area)
.fill (lambda{|d| color.scale(d)}).

#vedere perchè il color non funge e perchè non funziona l'altro file areastacked

=begin
vis.add(Rubyvis::Layout::Stack)
 .layers([[1, 1.2, 1.7, 1.5, 1.7],
          [0.5, 1, 0.8, 1.1, 1.3],
          [0.2, 0.5, 0.8, 0.9, 1]])
 .x(lambda { index * 35})
 .y(lambda {|d| d * 40})
 .layer.add(Rubyvis::Area)
=end
vis.render();
f = File.new(File.dirname(__FILE__)+"/fixtures/stacked_fromStackFile.svg", "w")
f.puts vis.to_svg
f.close