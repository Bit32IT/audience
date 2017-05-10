module Audience
  module Segmentable
    extend ActiveSupport::Concern

    included do
      Audience.member_class = self
    end

    def in_segment?(name)
      Audience.segment(name).include?(self)
    end

    def add_to_segment(name)
      Audience.segment(name).add(self)
    end

    def add_to_segments(*names)
      Array.wrap(names).each do |name|
        add_to_segment(name)
      end
    end

    def remove_from_segment(name)
      Audience.segment(name).remove(self)
    end

    def remove_from_segments(*names)
      Array.wrap(names).each do |name|
        remove_from_segment(name)
      end
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
