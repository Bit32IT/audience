<% module_namespacing do -%>
class <%= class_name %>Segment < ApplicationSegment
  def members
    # Required
  end

  def include?(member)
    # Required
  end

  def add(member)
    # Optional
  end

  def remove(member)
    # Optional
  end

  def each(&block)
    # Optional
  end

  def size
    # Optional
  end

  def sample(size)
    # Optional
  end
end
<% end -%>
