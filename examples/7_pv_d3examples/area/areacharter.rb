$:.unshift(File.dirname(__FILE__)+"/../../../lib")
require 'C:\Ruby193\rubyhw\rubyvis\examples\7_pv_d3examples\area\area.rb'
require 'benchmark'
#=begin
Benchmark.bm do |rep|
  data= Array.new()
  rep.report("caricamento") do

File.open("C:/Users/Andrea/Desktop/Formation/TriennaleInformatica/Stage/Valeria/Andrea_comma.txt", "r") do |aFile|
  aFile.each_line {|line|
    data << OpenStruct.new({:x=> line.split( /,/ )[0], :y=>line.split( /,/ )[1].chomp()})
  }
  end

end

#=end
=begin
data = Rubyvis.range(0, 1, 0.05).map {|x|
  OpenStruct.new({:x=> x*20/19, :y=> (Math.sin((x*20 / 3)) + 1) / 2})
}
=end
  rep.report("charting") do
Areachart.areacharter(data)  #you can insert the destination path as 2nd argument for the SVG file
    end
end