module Rubyvis
  # Alias for Rubyvis::Rule
  def self.Rule
    Rubyvis::Rule
  end
  class Rule < Mark
    include LinePrototype
    @properties=Mark.properties.dup
    attr_accessor_dsl :width, :height, :line_width, [:stroke_style, lambda {|d| Rubyvis.color(d)}], :name, :classrule, :x1, :x2, :y1, :y2, :stroke, :stroke_opacity, :shape_rendering, :stroke_width # IO ho aggiunto da classrule
    def self.defaults
      Rule.new.mark_extend(Mark.defaults).line_width(false).stroke_style('none').antialias(true).x1(nil).x2(nil).y1(nil).y2(nil).stroke_opacity(nil).shape_rendering(nil).stroke_width(nil) #IO modificato il line_width di default in false e lo stroke_style da black in none
    end
    
    def type
      'rule'
    end

    def anchor(name)
      line_anchor(name)
    end
    def build_implied(s)
      l=s.left
      r=s.right
      #t=s.top
      #b=s.bottom
      
      if((!s.width.nil?) or ((l.nil?) and (r.nil?)) or ((!r.nil?) and (!l.nil?)))
        s.height=0
      else
        s.width=0
      end
      mark_build_implied(s)
    end

    def children
      @children
    end

  end
end
