module Rubyvis
  module SvgScene
    def self.bar(scenes, gvs)
      scenes.each_with_index do |s,i|
        next unless s.visible
        next if(s.fill_opacity==0 and s.stroke_opacity==0)
        e=SvgScene.expect(e, 'rect', {
          "shape-rendering"=> s.shape_rendering,
          "pointer-events"=> s.events,
          "cursor"=> s.cursor,
          "x"=> s.x,
          "y"=> s.y ? ((/([0-9])+(\.)(([0-9]{2,30})|([1-9]))/ =~ s.y.to_s ) ? s.y : s.y.to_int).to_s : nil,
          "width"=> s.width,
          "height"=> s.height ? ((/([0-9])+(\.)(([0-9]{2,30})|([1-9]))/ =~ s.height.to_s ) ? s.height : s.height.to_int).to_s : nil,
          "fill"=> s.fill,
          "fill-opacity"=> s.fill_opacity,
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
