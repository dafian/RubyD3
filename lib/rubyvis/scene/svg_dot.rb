module Rubyvis
  module SvgScene
    def self.dot(scenes, gvs)
      #e = scenes._g.elements[1]
      #e=scenes._g.get_element(1) # IO non lo uso
      scenes.each_with_index {|s,i|
        s = scenes[i];

        # visible */
        next unless s.visible
        fill = s.fill_style
        stroke = s.stroke_style
        next if (fill.opacity==0 and stroke.opacity==0)

        #/* points */
        radius = s.shape_radius
        path = nil
        case s.shape
        when 'cross'
          path = "M#{-radius},#{-radius}L#{radius},#{radius}M#{radius},#{ -radius}L#{ -radius},#{radius}"
        when "triangle"
          h = radius
          w = radius * 1.1547; # // 2 / Math.sqrt(3)
          path = "M0,#{h}L#{w},#{-h} #{-w},#{-h}Z"
        when  "diamond"
          radius=radius* Math::sqrt(2)
          path = "M0,#{-radius}L#{radius},0 0,#{radius} #{-radius},0Z";
        when  "square"
          path = "M#{-radius},#{-radius}L#{radius},#{-radius} #{radius},#{radius} #{-radius},#{radius}Z"
        when  "tick"
          path = "M0,0L0,#{-s.shapeSize}"
        when  "bar"
          path = "M0,#{s.shape_size / 2.0}L0,#{-(s.shapeSize / 2.0)}"

        end

        #/* Use <circle> for circles, <path> for everything else. */
        svg = {
        "class" => s.classdot,    # IO aggiunto tutto
        "shape-rendering"=> s.shape_rendering,
        "pointer-events"=> s.events,
        "cursor"=> s.cursor,
        "fill"=> s.fill, # IO aggiunto la condizione
        "fill-opacity"=> s.fill_opacity,
        "stroke"=> s.stroke, # IO aggiunto la condizione
        "stroke-opacity"=> s.stroke_opacity,
        "stroke-width"=> s.stroke_width
        }

        if (path)
            svg["transform"] = "translate(#{(/([0-9])+(\.)(([0-9]{2,30})|([1-9]))/ =~ s.x.to_s ) ? s.x : s.x.to_int},#{(/([0-9])+(\.)(([0-9]{2,30})|([1-9]))/ =~ s.y0.to_s ) ? s.y0 : s.y0.to_int})"
            if (s.shape_angle)
              svg["transform"] += " rotate(#{180 * s.shape_angle / Math.PI})";
            end
          svg["d"] = path
          e = self.expect(e, "path", svg);
        else
          svg["cx"] = (/([0-9])+(\.)(([0-9]{2,30})|([1-9]))/ =~ s.cx.to_s ) ? s.cx : s.cx.to_int;
          svg["cy"] = (/([0-9])+(\.)(([0-9]{2,30})|([1-9]))/ =~ s.cy.to_s ) ? s.cy : s.cy.to_int;
          svg["r"] = radius;
          e = self.expect(e, "circle", svg);
        end
        #e = self.append(e, scenes, i);
        gvs.add_element(e)
      }
      return gvs
    end
  end
end

