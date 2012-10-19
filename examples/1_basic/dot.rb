# = Dot and anchors
# This example shows how looks differents positions of anchors on dots
$:.unshift(File.dirname(__FILE__)+"/../../lib")
require 'rubyvis'

vis = Rubyvis::Panel.new do |pan|
  pan.width(200)
  pan.height(400)
  pan.font_size("10px")
  pan.font_family("sans-serif")

  pan.dot do |dott|
    dott.data([1,2,3,4,5,6])
    dott.cy(lambda {|d| 200 - d*30})
    dott.cx(lambda { 20+index*40} )
    dott.shape_radius(10)
    dott.stroke("rgb(31,119,180)")
    dott.fill("none")
    dott.stroke_width("1.5px")
  end

  pan.label do |labt|
    labt.data ([1,2,3,4,5,6])
    labt.text("t")
    labt.fill("rgb(0,0,0)")
    labt.text_anchor("middle")
    labt.transform (lambda {|d| "translate(#{20+(d-1)*40},#{200 - (d-1)*30 - 40})"})
    labt.y (-3)
    labt.stroke_width("1.5px")
  end

  pan.label do |labb|
    labb.data ([1,2,3,4,5,6])
    labb.text("b")
    labb.fill("rgb(0,0,0)")
    labb.text_anchor("middle")
    labb.transform (lambda {|d|"translate(#{20+(d-1)*40},#{200 - (d-1)*30 - 20})"})
    labb.y (3)
    labb.dy (".71em")
    labb.stroke_width("1.5px")
  end

  pan.label do |labc|
    labc.data ([1,2,3,4,5,6])
    labc.text("c")
    labc.fill("rgb(0,0,0)")
    labc.text_anchor("middle")
    labc.transform (lambda {|d|"translate(#{20+(d-1)*40},#{200 - (d-1)*30 - 30})"})
    labc.dy (".35em")
    labc.stroke_width("1.5px")
  end

  pan.label do |labl|
    labl.data ([1,2,3,4,5,6])
    labl.text("l")
    labl.fill("rgb(0,0,0)")
    labl.text_anchor("end")
    labl.transform (lambda {|d|"translate(#{10+(d-1)*40},#{200 - (d-1)*30 - 30})"})
    labl.x (-3)
    labl.dy (".35em")
    labl.stroke_width("1.5px")
  end

  pan.label do |labr|
    labr.data ([1,2,3,4,5,6])
    labr.text("r")
    labr.fill("rgb(0,0,0)")
    labr.transform (lambda {|d|"translate(#{30+(d-1)*40},#{200 - (d-1)*30 - 30})"})
    labr.x (3)
    labr.dy (".35em")
    labr.stroke_width("1.5px")
  end
end
vis.render()

f = File.new(File.dirname(__FILE__)+"/fixtures/dot.svg", "w")
f.puts vis.to_svg
f.close