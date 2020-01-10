class SlideshowController < ApplicationController
    layout "slideshow"
    def slideshow
        @flayers = Flayer.all
      end
end
    