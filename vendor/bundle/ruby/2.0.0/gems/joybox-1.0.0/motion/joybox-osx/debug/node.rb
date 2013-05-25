module Joybox
  module Debug
    module Node

      def self.included(base)
        base.send(:attr_accessor, :proxy_view)
        base.send(:attr_accessor, :bounding_box_layer)
      end

      def initialize
        @proxy_view = ProxyView.alloc.initWithFrame(translated_bounding_box)
        @proxy_view.node = self
        Joybox.director.view.addSubview(@proxy_view)
      end

      def cleanup
        @proxy_view.removeFromSuperview
        super
      end

      def translated_bounding_box
        boundingBox
      end

      def setPosition(position)
        super
        update_bounding_box
      end

      def setContentSize(size)
        super
        @proxy_view.removeFromSuperview if boundingBox.size.width == Screen.width
        update_bounding_box
      end

      def nodeToParentTransform
        update_bounding_box
        super
      end


      private

      def update_bounding_box
        @proxy_view.frame = translated_bounding_box unless @proxy_view.nil?
        @bounding_box_layer.frame = @proxy_view.bounds unless @bounding_box_layer.nil?
      end

    end
  end
end