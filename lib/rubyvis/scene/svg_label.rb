module Rubyvis
  module SvgScene
    def self.label(scenes, tra)
      scenes.each_with_index do |s,i|
        next unless s.visible
        fill=s.text_style
        next if(fill.opacity==0 or s.text.nil?)
        unless s.angle.nil?
          r = (s.inner_radius + s.outer_radius) / 2
          s.start_angle = i>0 ? scenes[i-1].end_angle : -Math::PI.quo(2)
          s.end_angle = s.start_angle + s.angle
          a = ((s.start_angle + s.end_angle) / 2) - Math::PI.quo(2)
          ca = Math.cos(a) * r
          sa = Math.sin(a) * r
          s.centroid = "#{ca}, #{sa}"
          s.transform = s.transform == "centroid" ? "translate(" + "#{s.centroid}" + ")" : s.transform
        end

        e=SvgScene.expect(e,'text', {
          "class" => s.classlabel,
          "pointer-events"=> s.events,
          "cursor"=> s.cursor,
          "x"=> s.x ? ((/([0-9])+(\.)(([0-9]{2,30})|([1-9]))/ =~ s.x.to_s ) ? s.x : s.x.to_int).to_s : nil,
          "y"=> s.y ? (/([0-9])+(\.)(([0-9]{2,30})|([1-9]))/ =~ s.y.to_s ) ? s.y : s.y.to_int : nil,
          "dy"=> s.dy,
          "transform"=> s.transform,
          "fill"=> s.fill,
          "fill-opacity"=> s.fill_opacity,
          #"display"=>s.display,
          "text-anchor"=> s.text_anchor
        }, {
        "font"=> s.font, "text-shadow"=> s.text_shadow, "text-decoration"=> s.text_decoration})
        e.text=s.text.frozen? ? s.text.dup : s.text
        tra.add_element(e)
      end
      tra
    end
  end
end
