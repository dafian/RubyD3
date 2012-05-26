module Rubyvis
  module SvgScene
    def self.group(scenes, tra)

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
        tra.add_element(e) unless e.nil?
      }

      tra
    end

  end
end