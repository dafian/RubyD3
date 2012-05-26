$:.unshift(File.dirname(__FILE__)+"/../../../lib")
require 'rubyvis'
require 'C:\Ruby193\rubyhw\rubyvis\examples\7_pv_d3examples\area\area.rb'

data = Rubyvis.range(0, 1, 0.05).map {|x|
  OpenStruct.new({:x=> x*20/19, :y=> (Math.sin((x*20 / 3)) + 1) / 2})
}

Areachart.areacharter(data)
