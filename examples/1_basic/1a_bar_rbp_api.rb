# = First example (RBP API)
# This is the RBP API version of "Getting Started" example of Protovis introduction.
# On this example we  build a bar chart using panel and bar marks.
# A mark represents a set of graphical elements that share data and visual encodings. Although marks are simple by themselves, you can combine them in interesting ways to make rich, interactive visualizations
$:.unshift(File.dirname(__FILE__)+"/../../lib")
require 'rubyvis'
data = [1, 1.2, 1.7, 1.5, 0.7, 0.3]
    
vis = pv.Panel.new() do
  width 150
  height 150
  bar do
    data data
    width 20
    height {|d| d * 80}
    x {index * 25}
    y {|d| 150 - d * 80}
    fill "rgb(31,119,180)"
  end
end

vis.render

f = File.new(File.dirname(__FILE__)+"/fixtures/1a_bar_rbp_api.svg", "w")
f.puts vis.to_svg
f.close