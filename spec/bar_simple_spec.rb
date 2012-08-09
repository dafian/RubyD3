require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

describe "BarSimple" do
  include Rubyvis::GeneralSpec
  it "should render equal SVG elements to D3 'bar simple' test" do

    vis = pv.Panel.new do
      width 150
      height 150
      bar do
        data [1, 1.2, 1.7, 1.5, 0.7, 0.3]
        width 20
        height {|d| d * 80}
        x {index * 25}
        y {|d| 150 - d * 80}
        fill "rgb(31,119,180)"
      end
    end

    vis.render()
    pv_out=fixture_svg_read("bar_simple.svg")
    vis.to_svg.should have_same_svg_elements(pv_out)

  end
end