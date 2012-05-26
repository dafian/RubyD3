$:.unshift(File.dirname(__FILE__)+"/../../../lib")
require 'rubyvis'

data = Rubyvis.range(0, 1, 0.05).map {|x|
  OpenStruct.new({:x=> x*20/19, :y=> (Math.sin((x*20 / 3)) + 1) / 2})
}

w = 450
h = 275
p = 20

x = Rubyvis.Scale.linear(0,1).range(0, w)
y = Rubyvis.Scale.linear(0,1).range(h, 0)


vis = pv.Panel.new() do
  font_size "10px"
  font_family "sans_serif"
  width w + p * 2
  height h + p * 2

  group do
    transform ("translate(" + p.to_s + "," + p.to_s + ")")


    group do
      data x.ticks(10)
      classg('rule')

      # X-axis
      rule do
        stroke "#eee"
        shape_rendering "crispEdges"
        x1 x
        x2 x
        y1 0
        y2 h-1
      end

      # Y-axis
      rule do
        stroke {|d| d==0 ? "#000" : "#eee"}
        classrule{|d| d==0 ? "axis" : nil}
        shape_rendering "crispEdges"
        y1 y
        y2 y
        x1 0
        x2 w+1
      end

      # X-ticks
      label do
        x x
        y h + 3
        dy ".71em"
        text_anchor "middle"
        text(x.tick_format)
      end

      # Y-ticks
      label do
        y y
        x 3 * -1
        dy ".35em"
        text_anchor "end"
        text(y.tick_format)
      end

    end

    # The area
    area do
      data data
      y0 h - 1
      x {|d| x.scale(d.x)}
      y1 {|d| y.scale(d.y)}
      classarea("area")
      fill "lightsteelblue"
    end

    #The tops line
    line do
      data data
      stroke_width "1.5px"
      stroke "steelblue"
      fill "none"
      x {|d| x.scale(d.x)}
      y {|d| y.scale(d.y)}
      classline("line")
    end

    # The dots on the tops line
    dot do
      data data
      shape_radius(3.5)
      cx {|d| x.scale(d.x)}
      cy {|d| y.scale(d.y)}
      fill "#fff"
      stroke "steelblue"
      classdot("area")
      stroke_width "1.5px"
    end
  end
end

vis.render()
f = File.new('C:\Users\Andrea\Desktop\SVGhw\area.svg', "w")
f.puts vis.to_svg
f.close
