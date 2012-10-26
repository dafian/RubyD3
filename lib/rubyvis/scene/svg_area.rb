module Rubyvis
  module SvgScene
    def self.area(scenes, gvs)
      if (scenes[0].angle.nil? && scenes[0].end_angle.nil?)
        return if scenes.size==0
        s=scenes[0]
        # segmented
        return self.area_segment(scenes) if (s.segmented)
        # visible
        return e if (!s.visible)
        fill = s.fill_style
        stroke = s.stroke_style
        return e if (fill.opacity==0 and stroke.opacity==0)

        # Computes the straight path for the range [i, j]
        path=lambda {|ii,j|
          p1 = []
          p2 = []
          k=j
          (ii..k).each {|i|
            si = scenes[i]
            sj = scenes[j]

            #if horizon's layout

            if si.yt || si.yb
              if si.yt.nil?
                pi = "#{si.x},#{si.y0 - si.y1 + si.yb}" #si.y1+si.yt+si.yb
                pj = "#{sj.x},#{sj.y0  + sj.yb}"
              else
                pi = "#{si.x},#{si.yt}" #si.y0 - si.y1
                pj = "#{sj.x},#{sj.y1 + sj.yt}"
              end

            else
              pi = "#{si.x},#{si.y1}"
              pj = "#{sj.x + sj.width},#{sj.y0 + sj.height}"
            end

        #pi = "#{(/([0-9])+(\.)(([0-9]{2,30})|([1-9]))/ =~ si.left.to_s ) ? si.left : si.left.to_int},#{(/([0-9])+(\.)(([0-9]{2,30})|([1-9]))/ =~ si.top.to_s ) ? si.top: si.top.to_int}" # IO per eliminare i decimali uguali a zero e ho aggiunto il +1 perch� d3 lo fa in automatico
        #pi = "#{si.left},#{si.top}" # IO vedi sopra

        #pj = "#{(sj.left + sj.width)},#{(sj.top + sj.height)}" # IO vedi sopra
            puts "#{i}:"+pi+","+pj if $DEBUG
            #/* interpolate */

            if (i < k)
              sk = scenes[i + 1]
              sl = scenes[j - 1]
              case (s.interpolate)
                when "step-before"
                  #pi = pi+"V#{sk.top}"
                  pi = pi+"V#{sk.y1}"
                  pj = pj+"H#{sl.x + sl.width}"

                when "step-after"
                  pi = pi+"H#{sk.x}"
                  pj = pj+"V#{sl.y0 + sl.height}"
              end
            end
            p1.push(pi)
            p2.push(pj)
            j=j-1
          }

          (p1+p2).join("L");
        }

        # @private Computes the curved path for the range [i, j]. */
        path_curve=lambda {|ii, j|
          pointsT = []
          pointsB = []
          pathT=nil
          pathB=nil


          k=j
          (ii..k).each {|i|
            sj = scenes[j];
            pointsT.push(scenes[i])
            pointsB.push(OpenStruct.new({:x=> (sj.x + sj.width) , :y1=> (sj.y0)}))
            j=j-1
          }

          if (s.interpolate == "basis")
            pathT = Rubyvis::SvgScene.curve_basis(pointsT)
            pathB = Rubyvis::SvgScene.curve_basis(pointsB)
          elsif (s.interpolate == "cardinal")
              pathT = Rubyvis::SvgScene.curve_cardinal(pointsT, s.tension);
              pathB = Rubyvis::SvgScene.curve_cardinal(pointsB, s.tension);
          elsif # monotone
            pathT = Rubyvis::SvgScene.curve_monotone(pointsT);
            pathB = Rubyvis::SvgScene.curve_monotone(pointsB);
          end

          "#{pointsT[0].x },#{ pointsT[0].y1 }#{ pathT }L#{ pointsB[0].x},#{pointsB[0].y1}#{pathB}"
        }

        #/* points */
        d = []
        si=nil
        sj=nil
        i=0
        # puts "Scenes:#{scenes.size}, interpolation:#{scenes[0].interpolate}"

        while(i < scenes.size)
          si = scenes[i]

          if (si.y1==si.y0)#if (si.x==0 and si.y1==si.y0)
            i+=1
            next
          end


          j=i+1
          while(j<scenes.size) do
            sj=scenes[j]
            break if (sj.x == 0 and (sj.y0 - sj.y1) == 0)#(sj.y1==sj.y0)#if sj.x==0 and sj.y1==sj.y0
            j+=1
          end

          puts "j:#{j}" if $DEBUG

          i=i-1 if (i!=0 and (s.interpolate != "step-after"))

          j=j+1 if ((j < scenes.size) and (s.interpolate != "step-before"))

          d.push(((j - i > 2 and (s.interpolate == "basis" or s.interpolate == "cardinal" or s.interpolate == "monotone")) ? path_curve : path).call(i, j - 1))

          i = j - 1
          i+=1

        end

        return e if d.size==0
        e = self.expect(e, "path", {
          "class" => s.classarea ? s.classarea : nil, # IO aggiunto come fa in d3
          "shape-rendering"=> s.shape_rendering,
          "pointer-events"=> s.events,
          "cursor"=> s.cursor,
          "d"=> "M" + d.join("ZM") + "Z",
          "fill"=> s.fill,
          "fill-opacity"=> s.fill_opacity,
          "stroke"=> s.stroke,
          "stroke-opacity"=> s.stroke_opacity,
          "stroke-width"=> s.stroke_width
        })

        gvs ? gvs.add_element(e) : gvs = e

      else
        _p="M"
        _i="L"
        n=scenes.size
        scenes.each_with_index do |s,i|
          next unless s.visible
          fill=s.fill_style
          stroke=s.stroke_style
          next if(fill.opacity==0.0 and stroke.opacity==0.0)

          r1 = s.inner_radius
          r2 = s.outer_radius
          a1 = (s.angle).abs - Math::PI / 2
          a2 = (Math::PI * 2 - (s.angle).abs) - Math::PI / 2
          p0=r2 * Math.cos(a1)
          p1=r2 * Math.sin(a1)
          p2=r1 * Math.sin(a2)
          p3=r1 * Math.cos(a2)

          if i<n-1
            _p = _p + "#{p0},#{p1}L"
          else
            _p = _p + "#{p0},#{p1}"
          end
          if i<n-1
            _i = _i + "#{p3},#{p2}L"
          else
            _i = _i + "#{p3},#{p2}Z"
          end

        end
        e = self.expect(e, "path", {
            "class" => scenes[0].classarea,
            "shape-rendering"=> scenes[0].shape_rendering,
            "pointer-events"=> scenes[0].events,
            "cursor"=> scenes[0].cursor,
            "transform"=> scenes[0].transform,
            "d"=> _p + _i,
            "fill"=> scenes[0].fill,
            "fill-rule"=> scenes[0].fill_rule,
            "fill-opacity"=>  scenes[0].fill_opacity,
            "stroke"=> scenes[0].stroke,
            "stroke-opacity"=> scenes[0].stroke_opacity,
            "stroke-width"=> scenes[0].stroke_width
        })
        gvs.add_element(e)
      end
      gvs
    end
        
    def self.area_segment(scenes, gvs)
      s = scenes[0]
      pathsT=nil
      pathsB=nil
      if (s.interpolate == "basis" or s.interpolate == "cardinal" or s.interpolate == "monotone") 
        pointsT = []
        pointsB = []
        n=scenes.size
        n.times {|i|
          sj = scenes[n - i - 1]
          pointsT.push(scenes[i])
          pointsB.push(OpenStruct.new({:x=> (sj.x + sj.width), :y0=> (sj.y0 + sj.height)}));
        }
    
        if (s.interpolate == "basis") 
          pathsT = Rubyvis::SvgScene.curve_basis_segments(pointsT)
          pathsB = Rubyvis::SvgScene.curve_basis_segments(pointsB)
        elsif (s.interpolate == "cardinal")
            pathsT = Rubyvis::SvgScene.curve_cardinal_segments(pointsT, s.tension);
            pathsB = Rubyvis::SvgScene.curve_cardinal_segments(pointsB, s.tension);
        elsif # monotone
          pathsT = Rubyvis::SvgScene.curve_monotone_segments(pointsT)
          pathsB = Rubyvis::SvgScene.curve_monotone_segments(pointsB)
        end
      end
      
      n=scenes.size-1
      n.times {|i|
        
        s1 = scenes[i]
        s2 = scenes[i + 1]
    
        # /* visible */
        next if (!s1.visible or !s2.visible)
        
        fill = s1.fill
        stroke = s1.stroke
        next if (s.fill_opacity==0 and s.stroke_opacity==0)
        
        d=nil
        if (pathsT) 
          pathT = pathsT[i]
          pb=pathsB[n - i - 1]
          pathB = "L" + pb[1,pb.size-1]
          d = pathT + pathB + "Z";
        else 
          #/* interpolate */
          si = s1
          sj = s2
          
          case (s1.interpolate) 
            when "step-before"
              si = s2
            when "step-after"
              sj = s1
          end
          
    
          #/* path */
          d = "M#{s1.x},#{si.y1}L#{s2.x},#{sj.y0}L#{s2.x + s2.width},#{sj.y0 + sj.height}L#{s1.x + s1.width},#{si.y1 + si.height}Z"
        end
    
        e = self.expect(e, "path", {
            "class" => s.classarea, # IO aggiunto come fa in d3
            "shape-rendering"=> s.shape_rendering,
            "pointer-events"=> s.events,
            "cursor"=> s.cursor,
            "d"=> d,
            "fill"=> s.fill,
            "fill-opacity"=> s.fill_opacity,
            "stroke"=> s.stroke,
            "stroke-opacity"=> s.stroke_opacity,
            "stroke-width"=> s.stroke_width
          });
        gvs.add_element(e)
      }
      gvs
    end
  end
end

