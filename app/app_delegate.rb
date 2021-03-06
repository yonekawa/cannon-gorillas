class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    UIApplication.sharedApplication.setStatusBarHidden true, animated: false

    @director = Joybox::Configuration.setup do
      director display_stats: false
    end

    @navigation_controller = UINavigationController.alloc.initWithRootViewController(@director)
    @navigation_controller.navigationBarHidden = true

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.setRootViewController(@navigation_controller)
    @window.makeKeyAndVisible

    preload_resources

    @director << GameScene.new
    true
  end

  def preload_resources
    SimpleAudioEngine.sharedEngine.preloadEffect('get.mp3')
    SimpleAudioEngine.sharedEngine.preloadEffect('jump.mp3')
    SimpleAudioEngine.sharedEngine.preloadEffect('bomb.mp3')
  end

  def applicationWillResignActive(app)
    @director.pause if @navigation_controller.visibleViewController == @director
  end

  def applicationDidBecomeActive(app)
    @director.resume if @navigation_controller.visibleViewController == @director
  end

  def applicationDidEnterBackground(app)
    @director.stop_animation if @navigation_controller.visibleViewController == @director
  end

  def applicationWillEnterForeground(app)
    @director.start_animation if @navigation_controller.visibleViewController == @director
  end

  def applicationWillTerminate(app)
    @director.end
  end

  def applicationDidReceiveMemoryWarning(app)
    @director.purge_cached_data
  end

  def applicationSignificantTimeChange(app)
    @director.set_next_delta_time_zero true
  end
end
