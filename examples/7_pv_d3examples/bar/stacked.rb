$:.unshift(File.dirname(__FILE__)+"/../../../lib")
require 'rubyvis'

w = 960
h = 500
p = [20, 50, 30, 20]
x = pv.range(0, w - p[0] - p[3])
y = pv.range(0, h - p[0] - p[2])
z = ["lightpink", "darkgray", "lightblue"]
parse = Rubivis::Format.date("%m%y").parse
format = pv.Format.date("%b")


vis = pv.Panel.new() do
  width w
  height h

  group do
    transform "translate(" + p[3].to_s + "," + (h - p[2]).to_s + ")"


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