# = Area Interpolation
# This example show the 5 types of interpolation available for areas:
# * linear
# * step-before
# * step-after
# * basis
# * cardinal
# 
# See also "Line Interpolation":line_interpolation.html
$:.unshift(File.dirname(__FILE__)+"/../../lib")
require 'rubyvis'

data = Rubyvis.range(0, 10, 0.5).map {|x| 
  OpenStruct.new({:x=> x, :y=> Math.sin(x)})# + 2+rand()*0.3
}

p_w=200
p_h=150
#p data
w = 20+p_w*2
h = 20+p_h*3

x = Rubyvis.Scale.linear(data, lambda {|d| d.x}).range(0, p_w-30)
y = Rubyvis.Scale.linear(data, lambda {|d| d.y}).range(p_h-20, 0);
interpolations=["linear","step-before","step-after", "basis", "cardinal"]

vis = Rubyvis::Panel.new do |pan|
  pan.width w + 30
  pan.height h + 25
  pan.font_size "10px"
  pan.font_family "sans-serif"

  pan.group do |gro|
    gro.transform "translate(20,5)"

    interpolations.each_with_index do |inter,i|
      n=i%2
      m=(i/2).floor

        gro.panel do
        width p_w
        height p_h

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
          # uses 'a' as reference inside block
          # to use data method with data variable

          area do |a|
            a.data data
            a.x {|d| x.scale(d.x)}
            a.y1 {|d| y.scale(d.y) - 1 + 20}
            a.y0 p_h - 1
            a.fill ("rgb(31,119,180)")
            a.interpolate inter
          end
        end
      end
    end
  end
end

vis.render();

f = File.new(File.dirname(__FILE__)+"/fixtures/area_interpolation.svg", "w")
f.puts vis.to_svg
f.close