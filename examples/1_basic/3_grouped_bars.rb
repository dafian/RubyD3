# = Using parent
# This example shows how to group bars on groups and use the parent property to identify and color them
$:.unshift(File.dirname(__FILE__)+"/../../lib")
require 'rubyvis'

h = 150
w = 200

color = Rubyvis::Colors.category20

vis = pv.Panel.new()
    .width(w)
    .height(h)
    .font_size("10px")
    .font_family("sans-serif")

bar= vis.add(pv.Panel)
    .data(["a","b","c","d"])
    .add(pv.Bar)
    .data([1,2])
    .width(20)
    .height(lambda {60+parent.index*20+index*5})
    .x(lambda {|d,t| parent.index*60+index*25})
    .y(lambda {h - (60+parent.index*20+index*5)})
    .fill(lambda{color.scale(self.parent.index)})
    
 bar.add(pv.Label).
   text(lambda {|d,t| "#{t}-#{d}"})
   .fill("rgb(0,0,0)")
   .text_anchor("middle")
   .x(lambda {|d,t| 10 + parent.index*60+index*25})
   .y(h - 3)

 bar.add(pv.Label).
   text(lambda {"#{parent.index}-#{index}"})
   .fill("rgb(0,0,0)")
   .text_anchor("middle")
   .x(lambda {|d,t| 10 + parent.index*60+index*25})
   .y(lambda {3 + h - (60+parent.index*20+index*5)})
   .dy(".71em")
    
    
vis.render()

f = File.new(File.dirname(__FILE__)+"/fixtures/3_grouped_bars.svg", "w")
f.puts vis.to_svg
f.close
