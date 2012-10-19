# = Grid
# A simple heatmap, using a Bar.fill_style to represent
# data
$:.unshift(File.dirname(__FILE__)+"/../../lib")
require 'rubyvis'

w = 400
h = 400

arrays=10.times.map {|i| 10.times.map {|j| i/10.0+j/100.0}}

vis = pv.Panel.new() do
  width(w)
  height(h)
  font_size("10px")
  font_family("sans-serif")
end
vis.add(Rubyvis::Layout::Grid).
    rows(arrays).
    cell.add(Rubyvis::Bar).
      fill(Rubyvis.ramp("white", "black"))
      .add(Rubyvis::Label)
        .fill(Rubyvis.ramp("black","white"))
        .dy(".35em")
        .transform("translate(20,20)")
        .text_anchor("middle")

vis.render();

f = File.new(File.dirname(__FILE__)+"/fixtures/grid.svg", "w")
f.puts vis.to_svg
f.close

