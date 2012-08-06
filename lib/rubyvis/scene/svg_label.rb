module Rubyvis
  module SvgScene
    def self.label(scenes, gvs)
      scenes.each_with_index do |s,i|
        next unless s.visible
        fill=s.text_style
        next if(fill.opacity==0 or s.text.nil?)

        if s.transform == "centroid"
          tem = nil
          k=0
          while tem.nil?
            scenes.parent[k].children.each_with_index do |child, j|
              if child == scenes
                t=0
                while t<j && tem.nil?
                  if scenes.parent[k].children[t].type == "wedge"
                    tem = scenes.parent[k].children[t][0].centroid
                  end
                  t = t+1
                end
              end
            end
            k=k+1
          end
          s.transform = "translate(" + tem + ")"
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
        e.text=s.text.frozen? ? s.text.dup : (/^[0-9]+$/.match s.text.to_s ) ? s.text.to_s + ".0" : s.text.to_s #s.text
        gvs.add_element(e)
      end
      gvs
    end
  end
end