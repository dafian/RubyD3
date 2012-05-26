require 'rubyvis'
@h=300
    @w=200
    @vis = Rubyvis.Panel.new.width(@w).height(@h)
    @bar=@vis.add(pv.Bar).data([1,3]).width(20).height(lambda {|d| d * 80}).bottom(0).left(lambda {self.index * 5});
      @vis.render()
f1=File.open('C:\Users\Andrea\Desktop\newsvg.svg', "w")
f1.puts @vis.to_svg
f1.close

