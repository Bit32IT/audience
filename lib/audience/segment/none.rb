module Audience
  module Segment
    class None < Base
      def members
        Audience.member_class.none
      end

      def include?(_)
        false
      end

      def add(_)
      end

      def remove(_)
      end
    end
  end
end

Audience.register_segment(:none, Audience::Segment::None)
