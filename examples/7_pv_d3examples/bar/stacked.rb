$:.unshift(File.dirname(__FILE__)+"/../../../lib")
require 'rubyvis'

w = 960
h = 500
p = [20, 50, 30, 20]
height = 400
outerRadius = width / 2
innerRadius = outerRadius * 0.6
data = pv.range(0,1,0.1).map {rand()}
color = Rubyvis::Colors.category20
a = pv.Scale.linear(0, pv.sum(data)).range(0, 2 * Math::PI)


vis = pv.Panel.new() do
  width width
  height height

  group do
    width 0
    height 0
    data (data.sort(&pv.reverse_order))
    classg 'arc'
    transform "translate(" + outerRadius.to_s + "," + outerRadius.to_s + ")"

    wedge do
      dy '.35em'
      innerRadius innerRadius
      outerRadius outerRadius
      angle a
      fill_style color
      #event("mouseover", lambda {self.inner_radius(0)})
      #event("mouseout", lambda{ self.inner_radius(r - 40)})

      label(:anchor => 'center') do
        dy '.35em'
        transform true
        text_anchor 'middle'
        visible(lambda {|d|  d > 0.15})
        text(lambda {|d| "%0.2f" %  d});
      end

    end

  end

end