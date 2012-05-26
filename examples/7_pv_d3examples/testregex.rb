$:.unshift(File.dirname(__FILE__)+"/../../lib")
require 'rubyvis'

data = pv.range(10).map {rand()}

data.each_with_index{|d|
  puts d
  puts (((/([0-9])+(\.)(([0-9]{2,30})|([1-9]))/ =~ d.to_s ) ? d : d.to_int).to_s)
  puts "__________________"
}