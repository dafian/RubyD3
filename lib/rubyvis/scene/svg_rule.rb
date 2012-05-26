module Rubyvis
  module SvgScene
    def self.rule(scenes, tra)
      scenes.each_with_index do |s,i|
        next unless s.visible
        stroke=s.stroke_style
        next if(stroke.opacity==0.0)

        _x1 = (/([0-9])+(\.)(([0-9]{2,30})|([1-9]))/ =~ s.x1.to_s ) ? s.x1 : s.x1.to_int
        _x2 = (/([0-9])+(\.)(([0-9]{2,30})|([1-9]))/ =~ s.x2.to_s ) ? s.x2 : s.x2.to_int
        _y1 = (/([0-9])+(\.)(([0-9]{2,30})|([1-9]))/ =~ s.y1.to_s ) ? s.y1 : s.y1.to_int
        _y2 = (/([0-9])+(\.)(([0-9]{2,30})|([1-9]))/ =~ s.y2.to_s ) ? s.y2 : s.y2.to_int

        e=SvgScene.expect(e,'line', {
          "class" => s.classrule,
          "shape-rendering"=> s.shape_rendering,
          "pointer-events"=> s.events,
          "cursor"=> s.cursor,
          "x1"=> _x1,
          "y1"=> _y1,
          'x2'=> _x2,
          'y2'=> _y2,
          "stroke"=> s.stroke,
          "stroke-opacity"=> s.stroke_opacity,
          "stroke-width"=> s.stroke_width
        })

        tra.add_element(e)
      end
      tra
    end
  end
end
