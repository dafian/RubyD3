module Rubyvis
  module SvgScene
    def self.rule(scenes, gvs)
      scenes.each_with_index do |s,i|
        next unless s.visible
        stroke=s.stroke_style
        next if(stroke.opacity==0.0)

        _x1 = s.x1
        _x2 = s.x2
        _y1 = s.y1
        _y2 = s.y2

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

        gvs.add_element(e)
      end
      gvs
    end
  end
end
