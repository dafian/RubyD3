$:.unshift(File.dirname(__FILE__)+"/../../../lib")
require 'rubyvis'
require 'benchmark'

# BIO::Image::NGS::Profile
# BIO::Image::Profile::NGS    in quanto in profile è possibile visualizzare anche dati provenienti da altri tipi di tecnologie e.g. microarrays

class Areachart
  def Areachart.areacharter(data, path = "C:/Users/Andrea/Desktop/area_charter.svg")
    Benchmark.bm do |rep|
    w = 1300
    h = 600
    p = 25
    x_lin_min = data[0].x
    x_lin_max = data[data.length-1].x
    ret=nil
    data.each{|op|
       if ret.nil? || ret > op.y
         ret = op.y
       end
    }
    y_lin_min = ret
    ret=nil
    data.each{|op|
      if ret.nil? || ret < op.y
        ret = op.y
      end
    }
    #y_lin_max = ret
    y_lin_max = 1150

    x = Rubyvis.Scale.linear(x_lin_min,x_lin_max).range(0, w)
    y = Rubyvis.Scale.linear(y_lin_min,y_lin_max).range(h, 0)


    vis = pv.Panel.new() do
      font_size "10px"
      font_family "sans_serif"
      width w + p * 2
      height h + p * 2

      group do
        transform ("translate(" + p.to_s + "," + p.to_s + ")")


        group do

          classg('rule')

          # X-axis
          rule do
            data x.ticks(25)
            stroke "#eee"
            shape_rendering "crispEdges"
            x1 x
            x2 x
            y1 0
            y2 h-1
          end

          # Y-axis
          rule do
            data y .ticks(80)
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
            data x.ticks(25)
            x x
            y h + 3
            dy ".71em"
            text_anchor "middle"
            text(x.tick_format)
          end

          # Y-ticks
          label do
            data y.ticks(40)
            y y
            x 3 * -1
            dy ".35em"
            text_anchor "end"
            text(y.tick_format)
          end

        end
        rep.report("areavis") do
        # The area
        area do
          data data
          y0 h - 1
          x {|d| x.scale(d.x)}
          y1 {|d| y.scale(d.y)}
          classarea("area")
          fill "lightsteelblue"
        end
        end

        rep.report("linevis") do
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
        end
=begin
        # The dots on the tops line
        dot do
          data data
          shape_radius(2)
          cx {|d| x.scale(d.x)}
          cy {|d| y.scale(d.y)}
          fill "#fff"
          stroke "steelblue"
          classdot("area")
          stroke_width "1.5px"
        end
=end
      end
    end
    rep.report("rendering") do
    vis.render()
    end
    rep.report("to_svg") do
    f = File.new("#{path}", "w")
    f.puts vis.to_svg
    f.close
    end
    end
  end
end