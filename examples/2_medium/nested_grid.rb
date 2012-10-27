# = Nested grid
# Two level nested grid.  The first is created at random with n rows and m columns The second level is a 9x9 grid inside the cell of first level
# You can obtain the same result using a grid layout
$:.unshift(File.dirname(__FILE__)+"/../../lib")
require 'rubyvis'


w = 600
h = 600
cs=pv.Colors.category20()
rows=2.0+rand(3)
cols=2.0+rand(3)
row_h=h/rows
col_w=w/cols
cel_h=row_h/3.0
cel_w=col_w/3.0

letters=%w{a b c d e f g h i j k}

    
vis = pv.Panel.new()
    .width(w)
    .height(h)
    .font_size("10px")
    .font_family("sans-serif");
    
p1=vis.add(pv.Group).
    data(letters[0,rows]).
    transform(lambda {|d| "translate(#{0},#{letters.index(d) * row_h})"})

p2=p1.add(pv.Group).
    data(letters[0,cols]).
    transform(lambda {|d| "translate(#{letters.index(d) * col_w},#{0})"})

p2.add(pv.Label).
  text(lambda {|d,a,b| return "#{b}-#{a}"}).
  font("bold large Arial").
  dy(".35em").
  fill("rgb(0,0,0)").
  text_anchor("middle").
  transform("translate(#{w/(2*cols)},#{h/(2*rows)})")

p2.add(pv.Bar).data([1,2,3,4,5,6,7,8,9]).
  width(-3+cel_w).
  height(-3+cel_h).
  visible(lambda {|d| d!=5}).
  fill(lambda {|d| cs.scale(d)}).
  y(lambda { (index / 3.0).floor*cel_h}).
  x(lambda { (index % 3)*cel_w}).
    add(pv.Label).
      visible(lambda {|a,b,c| a!=5}).
      text(lambda {|a,b,c| "#{c}-#{b}-#{a}"}).
      transform(lambda {|d| "translate(#{(-3+cel_w)/2},#{(-3+cel_h)/2})"}).
      fill("rgb(0,0,0)").
      dy(".35em").
      text_anchor("middle")

vis.render();

f = File.new(File.dirname(__FILE__)+"/fixtures/nested_grid.svg", "w")
f.puts vis.to_svg
f.close
