$:.unshift(File.dirname(__FILE__)+"/../../../lib")
require 'C:\Ruby193\rubyhw\rubyvis\examples\7_pv_d3examples\area\area.rb'
require 'benchmark'

Benchmark.bm do |rep|
  data= Array.new()
  rep.report("caricamento") do

  File.open(File.dirname(__FILE__)+"/fixtures/INGM_comma.txt", "r") do |aFile|
    aFile.each_line {|line|
      data << OpenStruct.new({:x=> line.split( /,/ )[0], :y=>line.split( /,/ )[1].chomp()})
    }
  end
end

  rep.report("charting") do
Areachart.areacharter(data)  #you can insert the destination path as 2nd argument for the SVG file
    end
end