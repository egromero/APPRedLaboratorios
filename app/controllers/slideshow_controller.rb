class SlideshowController < ApplicationController
    layout "slideshow"
    def slideshow
        @images = Dir.entries("app/assets/images/").select{ |entry| entry[/\.jpe?g$/] || entry[/\.pne?g$/] }.reject{|entry| entry == "bg.jpg"}
      end
end
    