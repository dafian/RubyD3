# = Horizon
# Horizon graphs increase data density while preserving resolution. 
# While horizon graphs may require learning, they have been found to be more effective than standard line and area plots when chart sizes are small. For more, see "Sizing the Horizon: The Effects of Chart Size and Layering on the Graphical Perception of Time Series Visualizations" by Heer et al., CHI 2009.
# This example shows +offset+ and +mirror+ modes for the quadratic equation x^2-10
$:.unshift(File.dirname(__FILE__)+"/../../lib")
require 'rubyvis'

data = Rubyvis.range(-5, 5, 0.1).map {|x|
  OpenStruct.new({:x=> x, :y=>  x**2-10})
}

#p data
w = 400
h = 100
x = pv.Scale.linear(data, lambda {|d| d.x}).range(0, w)
y = pv.Scale.linear(data, lambda {|d| d.y}).range(-50, h*2);

#/* The root panel. */
vis = pv.Panel.new() do |pan|
  pan.width(w + 30)
  pan.height(h*2+45)
  pan.font_size("10px")
  pan.font_family("sans-serif")

  types=["offset","mirror"]

  pan.group do |gr|
    gr.transform "translate(20,5)"

    gr.group do |gro|


      gro.data(types)
      gro.transform(lambda {|d| "translate(#{0},#{types.index(d)*110+30})"})
      gro.width(w)
      gro.height(h - 20)

      gro.rule do |ru|
        ru.data(x.ticks)
        ru.x1(x)
        ru.x2(x)
        ru.y1(0)
        ru.y2(80)
        ru.shape_rendering("crispEdges")
        ru.stroke("rgb(0,0,0)")
        ru.stroke_width 1
      end

      gro.label do |la|
        la.data x.ticks
        la.text(x.tick_format)
        la.y 3
        la.dy ".71em"
        la.transform (lambda {|d| "translate(#{ x.scale(d)},#{80})"})
        la.text_anchor "middle"
      end

      gro.add(Rubyvis::Layout::Horizon)
         .bands(3)
         .mode(lambda {|d| d})
         .band
           .add(Rubyvis::Area)
           .data(data)
           .x(lambda {|d| x[d.x]})
           .y1(lambda {|d| h - 20 - y[d.y]})
           .y0(lambda {|d| y[d.y]})

      gro.label do

      end
    end
  end
end

vis.render();

f = File.new(File.dirname(__FILE__)+"/fixtures/horizon.svg", "w")
f.puts vis.to_svg
f.close