$:.unshift(File.dirname(__FILE__)+"/../../../lib")
require 'rubyvis'

r = 960 / 2

data = Rubyvis.range(0, 361, 1).map {|i| 0.8 + Math.sin(i * Math::PI / 20 ) / 6}

vis = pv.Panel.new() do

  width r * 2
  height r * 2
  
  group do
    transform "translate(" + r.to_s + "," + r.to_s + ")"

    area do
      data data
      classarea "area"
      inner_radius r/2
      outer_radius{|d| d * r}
      angle {index * Math::PI / 180 }
      fill "lightsteelblue"
      fill_rule "evenodd"

    end

    line do
      data data
      classline "line"
      radius {|d| d * r}
      angle { index * Math::PI/180}
      stroke "steelblue"
      fill "none"
      stroke_width "1.5px"
    end

  end

end
  

vis.render()

f = File.new('C:\Users\Andrea\Desktop\SVGhw\area-radial.svg', "w")
f.puts vis.to_svg
f.close