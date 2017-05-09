module Audience
  module Segment
    class Base
      attr_accessor :name
      delegate :each, :find_each, to: :members

      def initialize(*args)
      end

      def members
        raise NotImplementedError
      end

      def include?(user)
        raise NotImplementedError
      end

      def add(user)
        raise NotImplementedError
      end

      def delete(user)
        raise NotImplementedError
      end
    end
  end
end
