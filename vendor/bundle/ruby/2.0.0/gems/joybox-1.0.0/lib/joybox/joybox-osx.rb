Motion::Project::App.setup do |app|

  # Extracted from Teacup: https://github.com/rubymotion/teacup
  # Thanks Colin! (@colinta)
  platform = app.respond_to?(:template) ? app.template : :ios
  
  platform_joybox = File.expand_path(File.join(File.dirname(__FILE__), "../../motion/joybox-#{platform}"))
  platform_vendor = File.expand_path(File.join(File.dirname(__FILE__), "../../vendor/vendor-#{platform}"))


  app.frameworks += ["Cocoa", 
                     "OpenGL", 
                     "QuartzCore", 
                     "ApplicationServices",
                     "AppKit",
                     "CoreData",
                     "Foundation",
                     "JavaScriptCore",
                     "CoreGraphics"]

  app.libs << "/usr/lib/libz.dylib"
  app.libs << "/usr/lib/libffi.dylib"
  

  cocos2d_vendor = File.expand_path(File.join(platform_vendor, "cocos_2d"))
  box2d_vendor = File.expand_path(File.join(platform_vendor, "box_2d"))

  app.vendor_project(cocos2d_vendor,
                     :static,
                     :products => ["libcocos2d.a"],
                     :bridgesupport_cflags => "-D__CC_PLATFORM_MAC -ISupport -IPlatforms -IPlatforms/Mac")

  app.vendor_project(box2d_vendor,
                     :static,
                     :products => ['libBox2D.a'],
                     :bridgesupport_cflags => "-D__CC_PLATFORM_MAC -ISupport -IPlatforms -IPlatforms/Mac")


  # Scans app.files until it finds app/ (the default)
  # if found, it inserts just before those files, otherwise it will insert to
  # the end of the list
  insert_point = app.files.find_index { |file| file =~ /^(?:\.\/)?app\// } || 0

  Dir.glob(File.join(platform_joybox, '**/*.rb')).reverse.each do |file|
    app.files.insert(insert_point, file)
  end
end