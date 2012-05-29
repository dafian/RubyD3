$:.unshift(File.dirname(__FILE__)+"/../../../lib")
require 'rubyvis'

data = pv.range(4).map {|i|
  pv.range(0, 10, 0.1).map {|x|
    OpenStruct.new({:x=> x, :y=> Math.sin(x) + rand() * 0.5 + 2})
  }
}


c=data