module Rubyvis
  # Alias for Rubyvis::Area
  def self.Area
    Rubyvis::Area
  end
  # Provides methods pertinents to area like-marks.
  module AreaPrototype  # :nodoc:
    def fixed
      {
        :line_width=> true,
        :line_join=> true,
        :stroke_style=> true,
        :fill_style=> true,
        :segmented=> true,
        :interpolate=> true,
        :tension=> true
      }
    end
    def area_build_instance(s)
      self.bind  # IO non so se è propriamente lecito
      binds = self.binds
      # Handle fixed properties on secondary instances. */
      if (self.index!=0)
        fixed = @binds.fixed
        #/* Determine which properties are fixed. */
        if (!fixed)
          binds.fixed=[]
          fixed = binds.fixed
          filter=lambda {|prop|
            if prop.fixed
              fixed.push(prop)
              false
            else
              true
            end
          }
          #      p binds.required
          binds.required = binds.required.find_all(&filter)
          #      p binds.required
          if (!self.scene[0].segmented)
            binds.optional = binds.optional.find_all(&filter)
          end
          
        end
        
        #    p binds.required


        #/* Copy fixed property values from the first instance. */
        fixed.each {|prop|
          name=prop.name
          s[name]=self.scene[0][name]
        }
        
        
        #    p binds.fixed
        #/* Evaluate all properties on the first instance. */
      else
        binds.required = binds._required
        binds.optional = binds._optional
        binds.fixed = nil
      end
      # pp binds
      mark_build_instance(s)
    end



    def area_bind
      mark_bind
      
      binds = self.binds
      required = binds.required
      optional = binds.optional
      
      optional.size.times {|i|
        prop = optional[i]
        prop.fixed = fixed.keys.include? prop.name
        
        if (prop.name == "segmented")
          required.push(prop)
        end
      }
      optional.delete_if {|v| v.name=='segmented'}
      # Cache the original arrays so they can be restored on build. */
      @binds._required = required
      @binds._optional = optional
    end


    def area_anchor(name)
      #scene=nil
      anchor=mark_anchor(name)
      anchor.interpolate(lambda {
        self.scene.target[self.index].interpolate
      }).eccentricity(lambda {
        self.scene.target[self.index].eccentricity
      }).tension(lambda {
        self.scene.target[self.index].tension
      })
      anchor
    end
  end
  
  # Represents an area mark: the solid area between two series of
  # connected line segments. Unsurprisingly, areas are used most frequently for
  # area charts.
  #
  # <p>Just as a line represents a polyline, the <tt>Area</tt> mark type
  # represents a <i>polygon</i>. However, an area is not an arbitrary polygon;
  # vertices are paired either horizontally or vertically into parallel
  # <i>spans</i>, and each span corresponds to an associated datum. Either the
  # width or the height must be specified, but not both; this determines whether
  # the area is horizontally-oriented or vertically-oriented.  Like lines, areas
  # can be stroked and filled with arbitrary colors.

  class Area < Mark
    include AreaPrototype
    @properties=Mark.properties.dup
    
    
  ##
  # :attr: width
  # The width of a given span, in pixels; used for horizontal spans. If the width
  # is specified, the height property should be 0 (the default). Either the top
  # or bottom property should be used to space the spans vertically, typically as
  # a multiple of the index.
  
  
  ##
  # :attr: height  
  # The height of a given span, in pixels; used for vertical spans. If the height
  # is specified, the width property should be 0 (the default). Either the left
  # or right property should be used to space the spans horizontally, typically
  # as a multiple of the index.
  
  
  ##
  # :attr: line_width  
  # The width of stroked lines, in pixels; used in conjunction with
  # <tt>strokeStyle</tt> to stroke the perimeter of the area. Unlike the
  # {@link Line} mark type, the entire perimeter is stroked, rather than just one
  # edge. The default value of this property is 1.5, but since the default stroke
  # style is null, area marks are not stroked by default.
  #
  # <p>This property is <i>fixed</i> for non-segmented areas. See
  # {@link pv.Mark}.
  
  
  ##
  # :attr: stroke_style
  # The style of stroked lines; used in conjunction with <tt>lineWidth</tt> to
  # stroke the perimeter of the area. Unlike the {@link Line} mark type, the
  # entire perimeter is stroked, rather than just one edge. The default value of
  # this property is null, meaning areas are not stroked by default.
  #
  # <p>This property is <i>fixed</i> for non-segmented areas. See
  # {@link pv.Mark}.
  #
  
  
  ##
  # :attr: fill_style  
  # The area fill style; if non-null, the interior of the polygon forming the
  # area is filled with the specified color. The default value of this property
  # is a categorical color.
  #
  # <p>This property is <i>fixed</i> for non-segmented areas. See
  # {@link pv.Mark}.
  
  
  ##
  # :attr: segmented  
  # Whether the area is segmented; whether variations in fill style, stroke
  # style, and the other properties are treated as fixed. Rendering segmented
  # areas is noticeably slower than non-segmented areas.
  #
  # <p>This property is <i>fixed</i>. See {@link pv.Mark}.
  
  
  ##
  # :attr: interpolate  
  # How to interpolate between values. Linear interpolation ("linear") is the
  # default, producing a straight line between points. For piecewise constant
  # functions (i.e., step functions), either "step-before" or "step-after" can
  # be specified. To draw open uniform b-splines, specify "basis".
  # To draw cardinal splines, specify "cardinal"; see also Line.tension()
  #
  # <p>This property is <i>fixed</i>. See {@link pv.Mark}.
  
  
  ##
  # :attr: tension  
  # The tension of cardinal splines; used in conjunction with
  # interpolate("cardinal"). A value between 0 and 1 draws cardinal splines with
  # the given tension. In some sense, the tension can be interpreted as the
  # "length" of the tangent; a tension of 1 will yield all zero tangents (i.e.,
  # linear interpolation), and a tension of 0 yields a Catmull-Rom spline. The
  # default value is 0.7.
  #
  # <p>This property is <i>fixed</i>. See {@link pv.Mark}.
    
    
    
    attr_accessor_dsl :width, :height, :line_width, [:stroke_style, lambda {|d| Rubyvis.color(d)}], [:fill_style, lambda {|d| Rubyvis.color(d)}], :segmented, :interpolate, :tension, :classarea, :y0, :start_angle, :end_angle, :angle, :inner_radius, :outer_radius, :x, :y1, :shape_rendering, :fill, :fill_opacity, :stroke, :stroke_opacity, :stroke_width, :fill_rule, :y, :yt, :yb # IO ho aggiunto da classarea in poi
    def type
      "area"
    end
    def bind
      area_bind
    end
    def build_instance(s)
      area_build_instance(s)
    end
    def self.defaults
      a= Rubyvis::Colors.category20
      Area.new.mark_extend(Mark.defaults).line_width(1.5).fill_style("none").interpolate('linear').tension(0.7).y0(nil).start_angle(lambda  {s=self.sibling; s ? s.end_angle: -Math::PI.quo(2) } ).inner_radius( 0 ).shape_rendering(nil).x(nil).y(nil)
	  end
    def anchor(name)

      that=self
      partial=lambda {|s| s.inner_radius!=0 ? true : s.angle < 2*Math::PI}
      mid_radius=lambda {|s| (s.inner_radius+s.outer_radius) / 2.0}
      mid_angle=lambda {|s| (s.start_angle+s.end_angle) / 2.0 }

      mark_anchor(name).left(lambda {
        s = self.scene.target[self.index];
        if (partial.call(s))
          case (self.name())
            when "outer"
              s.left + s.outer_radius * Math.cos(mid_angle.call(s))
            when "inner"
              s.left + s.inner_radius * Math.cos(mid_angle.call(s))
            when "start"
              s.left + mid_radius.call(s) * Math.cos(s.start_angle)
            when "center"
              s.left + mid_radius.call(s) * Math.cos(mid_angle.call(s))
            when "end"
              s.left + mid_radius.call(s) * Math.cos(s.end_angle)
            else
              s.left
          end
        else
          s.left
        end
      }).top(lambda {
        s = self.scene.target[self.index];
        if (partial.call(s))
          case (self.name())
            when "outer"
              s.top + s.outer_radius * Math.sin(mid_angle.call(s))
            when "inner"
              s.top + s.inner_radius * Math.sin(mid_angle.call(s))
            when "start"
              s.top + mid_radius.call(s) * Math.sin(s.start_angle)
            when "center"
              s.top + mid_radius.call(s) * Math.sin(mid_angle.call(s))
            when "end"
              s.top + mid_radius.call(s) * Math.sin(s.end_angle)
            else
              s.top
          end
        else
          s.top
        end

      }).text_align(lambda {
        s = self.scene.target[self.index];
        if (partial.call(s))
          case (self.name())
            when 'outer'
              that.upright(mid_angle.call(s)) ? 'right':'left'
            when 'inner'
              that.upright(mid_angle.call(s)) ? 'left':'right'
            else
              'center'
          end
        else
          'center'
        end
      }).text_baseline(lambda {
        s = self.scene.target[self.index];
        if (partial.call(s))
          case (self.name())
            when 'start'
              that.upright(s.start_angle) ? 'top':'bottom'
            when 'end'
              that.upright(s.end_angle) ? 'bottom':'top'
            else
              'middle'
          end
        else
          'middle'
        end
      }).text_angle(lambda {
        s = self.scene.target[self.index];
        a=0
        if (partial.call(s))
          case (self.name())
            when 'center'
              a=mid_angle.call(s)
            when 'inner'
              a=mid_angle.call(s)
            when 'outer'
              a=mid_angle.call(s)
            when 'start'
              a=s.start_angle
            when 'end'
              a=s.end_angle
          end
        end
        that.upright(a) ? a: (a+Math::PI)
      })
      area_anchor(name)
    end
    def build_implied(s)
      unless s.angle.nil? && s.end_angle.nil?
        if s.angle.nil?
          s.angle = s.end_angle - s.start_angle
        elsif s.end_angle.nil?
          s.end_angle = s.start_angle + s.angle
        end
      end
      s.height=0 if s.height.nil?
      s.width=0 if s.width.nil?
      mark_build_implied(s)
    end

    def mid_radius
      (inner_radius+outer_radius) / 2.0
    end
    def mid_angle
      (start_angle+end_angle) / 2.0
    end

    def self.upright(angle)
      angle=angle % (2*Math::PI)
      angle=(angle<0) ? (2*Math::PI+angle) : angle
      (angle < Math::PI/2.0) or (angle>=3*Math::PI / 2.0)

    end
    def upright(angle)
      angle=angle % (2*Math::PI)
      angle=(angle<0) ? (2*Math::PI+angle) : angle
      (angle < Math::PI/2.0) or (angle>=3*Math::PI / 2.0)
    end

    def children
      @children
    end
  end
end
