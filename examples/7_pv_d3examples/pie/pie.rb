$:.unshift(File.dirname(__FILE__)+"/../../../lib")
require 'rubyvis'

width = 400
height = 400
outerRadius = width / 2
innerRadius = outerRadius * 0.6
data = pv.range(0,1,0.1).map {|d| d}#{rand()}
color = Rubyvis::Colors.category20
a = pv.Scale.linear(0, pv.sum(data)).range(0, 2 * Math::PI)

vis = pv.Panel.new() do
  font_size "10px"
  font_family "sans_serif"
  width width
  height height

  group do
    data (data.sort(&pv.reverse_order))
    classg 'arc'
    transform "translate(" + outerRadius.to_s + "," + outerRadius.to_s + ")"

    wedge do
      dy '.35em'
      innerRadius innerRadius
      outerRadius outerRadius
      angle a
      fill color
    end

    label do
      dy '.35em'
      # per semplificare per avere la label in centro al wedge(centroid mode)) è necessario metterla dopo il wedge e deve essere specificato nel translate come nell'esempio
      transform "centroid"
      text_anchor 'middle'
      #display {|d| d > 0.15 ? nil : "none"} #non è possibile usare display perché da errore...
      visible(lambda {|d|  d > 0.15})
      text(lambda {|d| "%0.2f" %  d})
    end

  end
end


vis.render()

f = File.new('C:\Users\Andrea\Desktop\SVGhw\pie.svg', "w")
f.puts vis.to_svg
f.close