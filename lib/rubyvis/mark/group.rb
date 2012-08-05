module Rubyvis
  # Alias for Rubyvis::Group
  def self.Group
    Rubyvis::Group
  end
  # Represents a container of certain elements
  class Group < Mark
    @properties=Mark.properties.dup   

    attr_accessor_dsl :text, :width, :height, :font, :transform, :classg, :children
    # Group type
    def type
      'group'
    end
    # Default properties for group. See the individual properties for the default values.
    def self.defaults
      Group.new.mark_extend(Mark.defaults).events('none').text(Rubyvis.identity).font("10px sans-serif" ).classg(nil).transform(nil).width(nil).height(nil)
    end

    def add(type)
      child=type.new
      child.parent=self
      child.root=root
      child.child_index=children.size
      children.push(child)
      child
    end

    def children
      return @children
    end

    def _data
      return @_data
    end

    def build_instance(s)
      super(s)
      return if !s.visible
      s.children=[] if !s.children
      scale=self.scale
      n=self.children.size
      Mark.index=-1
      n.times {|i|
        child=children[i]
        child.scene=s.children[i]
        child.scale=scale
        child.build
      }
      n.times {|i|
        child=children[i]
        s.children[i]=child.scene
        child.scene=nil
        child.scale=nil
      }
      s.children=s.children[0,n]

    end
  end
end
