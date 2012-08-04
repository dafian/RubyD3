module Rubyvis
  module SvgScene
    def self.group(scenes, gvs)

      scenes.each_with_index{|s, ii|
        e=SvgScene.expect(e, "g", {
            "class" => s.classg,
            "transform"=> s.transform
        })
        if s.children.size>0
          s.children.each_with_index{|chi, ii|
            e = SvgScene.update_all(chi, e)
          }
        end
        gvs.add_element(e) unless e.nil?
      }

      gvs
    end

  end
end