module Audience
  module Segment
    class All < Base
      def members
        Audience.member_class.all
      end

      def include?(_)
        true
      end

      def add(_)
      end

      def remove(_)
      end
    end
  end
end

Audience.register_segment(:all, Audience::Segment::All.new)
