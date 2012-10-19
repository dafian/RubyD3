# = Line Interpolation
# This example show the 7 types of interpolation available for lines:
# * linear
# * step-before
# * step-after
# * polar
# * polar-reverse
# * basis
# * cardinal
# 
# See also "Area Interpolation":area_interpolation.html
$:.unshift(File.dirname(__FILE__)+"/../../lib")
require 'rubyvis'

data = pv.range(0, 10, 1).map {|x| 
  OpenStruct.new({:x=> x, :y=> Math.sin(x) })  # + 2+rand()*0.2
}

p_w=200
p_h=150
#p data
w = 20+p_w*2
h = 20+p_h*4

x = pv.Scale.linear(data, lambda {|d| d.x}).range(0, p_w-30)


y = pv.Scale.linear(data, lambda {|d| d.y}).range(p_h-20, 0);

interpolations=["linear","step-before","step-after","polar","polar-reverse", "basis", "cardinal"]

#/* The root panel. */
vis = Rubyvis::Panel.new() do |pan|
  pan.width(w + 30)
  pan.height(h + 25)
  pan.font_size "10px"
  pan.font_family "sans-serif"

  pan.group do |gro|
    gro.transform "translate(20,5)"

    interpolations.each_with_index do |inter,i|
      n=i%2
      m=(i/2).floor

      gro.panel do
      width(p_w)
      height(p_h)

      group do
        transform "translate(#{(n*(p_w+10)).to_s},#{(m*(p_h+10)).to_s})"

        label do
          text(inter)
          fill("rgb(0,0,0)")
          transform "translate(100,0)"
          y 3
          dy ".71em"
          text_anchor "middle"
        end

        line do |l|
          l.data data
          l.x (lambda {|d| x.scale(d.x)})
          l.y (lambda {|d| y.scale(d.y) + 20})
          l.fill ("rgb(31,119,180)")
          l.interpolate inter
          l.stroke_width(2)
          l.fill "none"
          l.stroke "rgb(31,119,180)"
        end
      end
    end
  end
 end
end
  
  
     

vis.render();
f = File.new(File.dirname(__FILE__)+"/fixtures/line_interpolation.svg", "w")
f.puts vis.to_svg
f.close
