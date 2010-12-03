CmsEngine::Base.init
require 'cms_engine/factories'

#Hack of the paperclip library to enable dirty objects to be set and unset (Adam Carlile 2010)
module Paperclip
  class Attachment
    def dirty=(value)
      @dirty = value
    end
  end
end