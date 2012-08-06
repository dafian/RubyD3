require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

describe "AreaRadial" do
  include Rubyvis::GeneralSpec
  it "should render equal SVG elements to D3 'area radial' test" do

    r = 960 / 2

    data = Rubyvis.range(0, 361, 1).map {|i| 0.8 + Math.sin(i * Math::PI / 20 ) / 6}

    vis = pv.Panel.new() do

      width r * 2
      height r * 2

      group do
        transform "translate(" + r.to_s + "," + r.to_s + ")"

        area do
          data data
          classarea "area"
          inner_radius r/2
          outer_radius{|d| d * r}
          angle {index * Math::PI / 180 }
          #fill "lightsteelblue"
          #fill_rule "evenodd"

        end

        line do
          data data
          classline "line"
          radius {|d| d * r}
          angle { index * Math::PI/180}
          #stroke "steelblue"
          #fill "none"
          #stroke_width "1.5px"
        end

      end

    end

    vis.render()
    pv_out=fixture_svg_read("area_radial.svg")
    vis.to_svg.should have_same_svg_elements(pv_out)

  end
end