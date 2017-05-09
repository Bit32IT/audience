module Audience
  module Segmentable
    extend ActiveSupport::Concern

    included do
      Audience.member_class = self
    end

    def in_segment?(name)
      Audience.registry(name).include?(self)
    end

    def segments
      Audience.segments.select do |segment|
        segment.include?(self)
      end
    end

    def segment_names
      segments.map(&:name)
    end

    module ClassMethods
      def segment(name)
        Audience.segment(name)
      end
    end
  end
end
