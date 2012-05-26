# = Image
# This example shows how to include an image 
$:.unshift(File.dirname(__FILE__)+"/../../lib")
require 'rubyvis'

img_url="fixtures/tipsy.gif"

vis = pv.Panel.new().width(200).height(200);

dot=vis.add(pv.Image)
    .data([1,2,3,4,5,6])
    .bottom(lambda {|d| d*30})
    .left(lambda {|d| d*30} )
    .width(9)
    .height(9)
    .url(img_url)
    
vis.render()
f = File.new('C:\Users\Andrea\Desktop\newsvg1.svg', "w") #crea o sovrascrive un file
f.puts vis.to_svg # stampa nel file
f.close # chiude il file
#puts vis.to_svg
