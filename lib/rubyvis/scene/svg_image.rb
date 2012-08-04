module Rubyvis
  module SvgScene
    def self.image(scenes, gvs)
      #e=scenes._g.elements[1]
      #e=scenes._g.get_element(1)
      scenes.each_with_index do |s,i|
        next unless s.visible
        #e=self.fill(e,scenes,i)
        gvs = self.fill(scenes, i, gvs) if(s.fill_style.opacity>0 or s.events=='all') # IO ho modificato
        if s.image
          raise "Not implemented yet"
        else
          e = self.expect(e, "image", {
          "preserveAspectRatio"=> "none",
          "cursor"=> s.cursor,
          "x"=> s.x,
          "y"=> s.y,
          "width"=> s.width,
          "height"=> s.height
          })
          
          e.add_attribute("xlink:href", s.url);
        end
        #e = self.append(e, scenes, i);
        gvs.add_element(e) # IO ho aggiunto
        #/* stroke */
        #e = self.stroke(e, scenes, i);
        gvs = self.stroke(scenes, i, gvs) if (s.stroke_style.opacity>0 or s.events == "all") # IO ho modificato
      end
      #e
      gvs # IO ho aggiunto
    end
  end
end
