module Rubyvis
  module SvgScene
    def self.bar(scenes, tra)
      scenes.each_with_index do |s,i|
        next unless s.visible
        next if(s.fill_opacity==0 and s.stroke_opacity==0)
        e=SvgScene.expect(e, 'rect', {
          "shape-rendering"=> s.shape_rendering,
          "pointer-events"=> s.events,
          "cursor"=> s.cursor,
          "x"=> s.x,
          "y"=> s.y,
          "width"=> s.width,
          "height"=> s.height,
          "fill"=> s.fill,
          "fill-opacity"=> s.fill_opacity,
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
