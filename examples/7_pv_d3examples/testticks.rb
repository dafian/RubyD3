$:.unshift(File.dirname(__FILE__)+"/../../lib")
require 'rubyvis'

data = Rubyvis.range(0, 1, 0.05).map {|x|   # DDD chiama internals
  OpenStruct.new({:x=> x*20/19, :y=> (Math.sin((x*20 / 3)) + 1) / 2})
}

w = 450
h = 275
p = 20

x = Rubyvis.Scale.linear(0,1).range(0, w)
y = Rubyvis.Scale.linear(0,1).range(0, h)

vis = pv.Panel.new() do
  width w         # DDD va in mark.property_method
  height h

data x.ticks(10)
puts data

end


puts data