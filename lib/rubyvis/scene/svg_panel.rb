module Rubyvis
  module SvgScene
    def self.panel(scenes, gvs=nil)
      puts " -> panel: #{scenes.inspect}" if $DEBUG
      g=scenes._g
      #e=(g.nil?) ? nil : g.elements[1]
      e=(g.nil?) ? nil : g.get_element(1)
      if g
        e=g.elements[1]
        e=g.get_element(1)
      end
      scenes.each_with_index do |s,i|
        next unless s.visible

        if(!scenes.parent)
          if g and g.parent!=s.canvas
            #g=s.canvas.elements[1]
            g=s.canvas.get_element(1)
            #e=(@g.nil?) ? nil : @g.elements[1]
            e=(@g.nil?) ? nil : @g.get_element(1)
          end
		      if(!g)
            g=s.canvas.add_element(self.create('svg'))
            #g.set_attributes(
            #  {
            #    'font-size'=>"10px", #not in d3
            #    'font-family'=>'sans-serif', #not in d3
            #    'fill'=>'none', #not in d3
            #    'stroke'=>'none', #not in d3
            #    'stroke-width'=>1.5 #not in d3
            #  }
            #)
            e=g.get_element(1)
            # g.attributes["font-size"]="10px" 
            # g.attributes["font-family"]="sans-serif"
            # g.attributes["fill"]="none"
            # g.attributes["stroke"]="none"
            # g.attributes["stroke-width"]=1.5
            # e=g.elements[1]
          end
          scenes._g=g
          #p s

          # IO aggiunto gli attributi opzionali invece che averne fissi
          if s.font_size then g.set_attributes({"font-size"=>s.font_size}) end
          if s.font_family then g.set_attributes({"font-family"=>s.font_family}) end
          if s.fill then g.set_attributes({"fill"=>s.fill}) end
          if s.stroke then g.set_attributes({"stroke"=>s.stroke}) end
          if s.stroke_width then g.set_attributes({"stroke-width"=>s.stroke_width}) end
          if s.width then g.set_attributes({"width"=>s.width}) end
          if s.height then g.set_attributes({"height"=>s.height}) end

          #g.attributes['width']=s.width+s.left+s.right
          #g.attributes['height']=s.height+s.top+s.bottom
        end
        if s.overflow=='hidden'
          g=SvgScene.expect(g, "g", {})
          id=Rubyvis.id.to_s(36)
          e = nil
          c=self.expect(e,'g',{'clip-path'=>'url(#'+id+')'});
          g.add_element(c) if(!c.parent)
          scenes._g=g=c
          #e=c.elements[1]
          e=c.get_element(1)
          e=self.expect(e,'clipPath',{'id'=>id})
          #r=(e.elements[1]) ? e.elements[1] : e.add_element(self.create('rect'))
          r=(e.get_element(1)) ? e.get_element(1) : e.add_element(self.create('rect'))
          r.set_attributes({
              'x'=>s.x,
              'y'=>s.y,
              'width'=>s.width,
              'height'=>s.height
          })
          #r.attributes['x']=s.left
          #r.attributes['y']=s.top
          #r.attributes['width']=s.width
          #r.attributes['height']=s.height
          g.add_element(e) if !e.parent
          s.children.each_with_index{|chi, ii|
            g = SvgScene.update_all(chi, g)
          }
          gvs.add_element(g)
          e=e.next_sibling_node
        end
        # fill
        #e=self.fill(e,scenes, i)
        gvs=g if gvs.nil?
        k=self.scale
        t=s.transform
        SvgScene.scale=SvgScene.scale*t.k
        #gvs=SvgScene.expect(e, "g", { "transform"=> "translate(" + x.to_s + "," + y.to_s + ")" + (t.k != 1 ? " scale(" + t.k.to_s + ")" : "")})
        gvs = self.fill(scenes, i, gvs) if(s.fill_style.opacity>0 or s.events=='all') # IO ho modificato
        # transform
        # children
=begin   # DDD come era un tempo
        s.children.each_with_index {|child, i2|
          child._g=e=SvgScene.expect(e, "g", {
            "transform"=> "translate(" + x.to_s + "," + y.to_s + ")" + (t.k != 1 ? " scale(" + t.k.to_s + ")" : "")
          })
          SvgScene.update_all(child)
          g.add_element(e) if(!e.parent)
          e=e.next_sibling_node
        }
=end

#=begin  # IO adesso per supportare le group
        if s.overflow != "hidden"
          s.children.each_with_index{|chi, ii|
            gvs = SvgScene.update_all(chi, gvs)
          }
          #g.add_element(gvs)
        end

        g=gvs
#=end
        # transform (pop)
        SvgScene.scale=k
        # stroke
        #e=SvgScene.stroke(e,scenes,i)
        #gvs = self.stroke(scenes, i, gvs) if (s.scenes.mark.root == scenes.markstroke_style.opacity>0 or s.events == "all") # IO ho modificato
        # clip
        if (s.overflow=='hidden')
          scenes._g=g=c.parent
          e=c.next_sibling_node
        end
      end
      #return e
      if scenes.mark.root == scenes.mark
        return e
      else
        return g
      end
      #scenes.mark.root == scenes.mark ? return e : return g
      #return g
      
    end



    #def self.fill(e,scenes,i)
    def self.fill(scenes, i, gvs)
      s=scenes[i]
      fill=s.fill_style
      e=SvgScene.expect(e,'rect', {
        "shape-rendering"=> s.antialias ? nil : "crispEdges",
        "pointer-events"=> s.events,
        "cursor"=> s.cursor,
        "x"=> s.x,
        "y"=> s.y,
        "height"=> s.height,
        "width"=> s.width,
        "fill"=> fill.color,
        "fill-opacity"=> fill.opacity,
        "stroke"=> nil
      })
      #e=SvgScene.append(e,scenes, i)
      gvs.add_element(e)
      #e
      gvs
    end


    #def self.stroke(e, scenes, i)
    def self.stroke(scenes, i, gvs=nil)
      s = scenes[i]
      stroke = s.stroke_style
      #if (stroke.opacity>0 or s.events == "all")
        e = self.expect(e, "rect", {
          "shape-rendering"=> s.antialias ? nil : "crispEdges",
          "pointer-events"=> s.events == "all" ? "stroke" : s.events,
          "cursor"=> s.cursor,
          "x"=> s.x,
          "y"=> s.y,
          "width"=> [1E-10, s.width].max,
          "height"=>[1E-10, s.height].max,
          "fill"=>"none",
          "stroke"=> stroke.color,
          "stroke-opacity"=> stroke.opacity,
          "stroke-width"=> s.line_width / self.scale.to_f
        });
        #e = self.append(e, scenes, i);
      gvs.add_element(e)
      #end
      #return e
      gvs
    end
  end
end
