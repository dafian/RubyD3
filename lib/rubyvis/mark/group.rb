module Rubyvis
  # Alias for Rubyvis::Group
  def self.Group
    Rubyvis::Group
  end
  # Represents a container of certain elements
  class Group < Mark
    @properties=Mark.properties.dup   
    ##
    # :attr: text
    # The character data to render; a string. The default value of the text
    # property is the identity function, meaning the label's associated datum will
    # be rendered using its to_s()
    
    ##
    # :attr: font
    # The font format, per the CSS Level 2 specification. The default font is "10px
    # sans-serif", for consistency with the HTML 5 canvas element specification.
    # Note that since text is not wrapped, any line-height property will be
    # ignored. The other font-style, font-variant, font-weight, font-size and
    # font-family properties are supported.
    #
    # @see {CSS2 fonts}[http://www.w3.org/TR/CSS2/fonts.html#font-shorthand]       
    attr_accessor_dsl :text, :width, :height, :font, :transform, :classg, :children
    # Group type
    def type
      'group'
    end
    # Default properties for group. See the individual properties for the default values.
    def self.defaults
      Group.new.mark_extend(Mark.defaults).events('none').text(Rubyvis.identity).font("10px sans-serif" ).classg(nil).transform(nil).width(nil).height(nil).right(0).left(0).bottom(0).top(0)
    end
=begin
    def initialize
      @children=[]
      @root=self
      super
    end
=end
    def add(type)  # BOO aggiunto il base
      child=type.new
      child.parent=self
      child.root=root
      child.child_index=children.size
      #self.children == [] ? child.child_index=0 : child.child_index=self.children.size
      children.push(child)
      child
    end

    def children   # IO aggiunto per poter gestire i children
      return @children
    end

    def _data
      return @_data
    end

    #def mark   # IO aggiunto per poter leggere i children nelle update_all
    #  return @mark
    #end

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
