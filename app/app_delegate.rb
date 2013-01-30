class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    fireworks_view_controller = FireworksViewController.alloc.init
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = fireworks_view_controller
    @window.makeKeyAndVisible
    true
  end
end
