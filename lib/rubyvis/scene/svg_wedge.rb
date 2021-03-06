module Rubyvis
  module SvgScene
    def self.wedge(scenes, gvs)
      scenes.each_with_index do |s,i|
        next unless s.visible
        fill=s.fill_style
        stroke=s.stroke_style
        next if(fill.opacity==0.0 and stroke.opacity==0.0)
        # /* points */
        
        r1 = s.inner_radius
        r2 = s.outer_radius

        a = (s.angle).abs
        _p=nil
        
        if (a >= 2 * Math::PI) 
          if (r1!=0) 
            _p = "M0,#{r2 }A#{r2},#{r2} 0 1,1 0,#{-r2}A#{r2 },#{r2 } 0 1,1 0,#{r2}M0,#{r1}A#{r1},#{r1} 0 1,1 0,#{-r1}A#{r1},#{r1} 0 1,1 0,#{r1 }Z"
          else 
            _p = "M0,#{r2}A#{r2},#{r2} 0 1,1 0,#{-r2}A#{r2},#{r2} 0 1,1 0,#{r2 }Z"
          end
        else
=begin
          sa = [s.start_angle, s.end_angle].min
          ea = [s.start_angle, s.end_angle].max
          c1 = Math.cos(sa)
          c2 = Math.cos(ea)
          s1 = Math.sin(sa)
          s2 = Math.sin(ea)
          if (r1!=0)
            _p = "M#{r2 * c1},#{r2 * s1}A#{r2},#{r2} 0 #{((a < Math::PI) ? "0" : "1")},1 #{r2 * c2},#{r2 * s2}L#{r1 * c2},#{r1 * s2}A#{r1},#{r1} 0 #{((a < Math::PI) ? "0" : "1")},0 #{r1 * c1},#{r1 * s1}Z"
          else 
            _p = "M#{r2 * c1},#{r2 * s1}A#{r2},#{r2} 0 #{((a < Math::PI) ? "0" : "1")},1 #{r2 * c2},#{r2 * s2}L0,0Z"
          end
        end
=end

            a0 = s.start_angle - Math::PI.quo(2)
            a1 = s.end_angle - Math::PI.quo(2)

            if a1 < a0
              da = a0, a0 = a1, a1 = da
            end
            da = a1 - a0
            df = da < Math::PI ? 0 : 1
            c0 = Math.cos(a0)
            s0 = Math.sin(a0)
            c1 = Math.cos(a1)
            s1 = Math.sin(a1)

            _p = da >= Math::PI * 2 ? r1 ? "M0,#{r2}A#{r2},#{r2} 0 1,1 0,#{-r2}A#{r2},#{r2} 0 1,1 0,#{r2}M0#{r1}A#{r1},#{r1} 0 1,0 0,#{-r1}A#{r1},#{r1} 0 1,0 0,#{r1}Z" : "M0,#{r2}A#{r2},#{r2} 0 1,1 0,#{-r2}A#{r2},#{r2} 0 1,1 0,#{r2}Z" : r1 ? "M#{r2*c0},#{r2*s0}A#{r2},#{r2} 0 #{df},1 #{r2*c1},#{r2*s1}L#{r1*c1},#{r1*s1}A#{r1},#{r1} 0 #{df},0 #{r1*c0},#{r1*s0}Z" : "M#{r2*c0},#{r2*s0}A#{r2},#{r2} 0 #{df},1 #{r2*c1},#{r2*s1}L0,0Z"
          end

          e = self.expect(e, "path", {
          "shape-rendering"=> s.shape_rendering,
          "pointer-events"=> s.events,
          "cursor"=> s.cursor,
          "transform"=> s.transform,
          "fill"=> s.fill,
          "d"=> _p,
          "fill-rule"=> s.fill_rule,
          "fill-opacity"=>  s.fill_opacity,
          "stroke"=> s.stroke,
          "stroke-opacity"=> s.stroke_opacity,
          "stroke-width"=> s.stroke_width
        });
		  gvs.add_element(e)
      end
	  gvs
    end

  end
end
