# = Image
# This example shows how to include an image 
$:.unshift(File.dirname(__FILE__)+"/../../lib")
require 'rubyvis'

img_url=File.dirname(__FILE__)+"/fixtures/tipsy.gif"

vis = pv.Panel.new().width(200).height(200);

dot=vis.add(pv.Image)
    .data([1,2,3,4,5,6])
    .y(lambda {|d| 191 - d*30})
    .x(lambda {|d| d*30} )
    .url(img_url)
    .width(9)
    .height(9)

    
vis.render()
f = File.new(File.dirname(__FILE__)+"/fixtures/image.svg", "w")
f.puts vis.to_svg
f.close
