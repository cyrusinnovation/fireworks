class FireworksViewController < UIViewController
  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    layout_background_layer
    create_fireworks
  end

  def layout_background_layer
    @background_layer = CAGradientLayer.layer
    @background_layer.frame = self.view.bounds

    colors = NSMutableArray.alloc.init
    colors.addObject(UIColor.colorWithWhite(0.051, alpha:1.0).CGColor)
    colors.addObject(UIColor.colorWithRed(0.157, green:0.173, blue:0.192, alpha:1.0).CGColor)
    colors.addObject(UIColor.colorWithRed(0.157, green:0.173, blue:0.192, alpha:1.0).CGColor)

    @background_layer.colors = colors
    @background_layer.locations = [0.0, 0.5, 1.0]
    self.view.layer.insertSublayer(@background_layer, atIndex:0)
  end

  def create_fireworks
    # Load the spark image for the particle
    img = UIImage.imageNamed('spark').CGImage

    mortar = CAEmitterLayer.layer.retain
    mortar.emitterPosition = CGPointMake(160, 420) #place where the fireworks will shoot out from
    mortar.renderMode = KCAEmitterLayerAdditive

    # Invisible particle (no contents set) representing the rocket before the explosion
    rocket = CAEmitterCell.emitterCell.retain
    rocket.emissionLongitude = (3 * Math::PI) / 2  #angle (radians) on xy plane at which the fireworks shoot (3pi/2 is up, 0 is to the right, pi is left and so forth)
    rocket.emissionLatitude = 0 #angle for z axis
    rocket.lifetime = 1.6 # seconds that this rocket cell will live
    rocket.birthRate = 4 # number of rockets that shoot per sec, making this smaller will shoot fewer rockets and higher will shoot out lots of fireworks
    rocket.velocity = 400 # speed
    rocket.velocityRange = 100 # varies the speed by 50 on either side of the base velocity
    rocket.yAcceleration = 250 # as the fireworks continue, they get slower toward the apex and slope downwards (towards the positive y direction) before exploding
    rocket.emissionRange = Math::PI / 4 # this is the total angle of variation that the fireworks will explode in (pi/8 in both direction of the emission longitude)
    color = UIColor.colorWithRed(0.5, green:0.5, blue:0.5, alpha:0.5).CGColor # this actually colors the children's images, need it to be in the middle for brighter color variation
    rocket.color = color
    CGColorRelease(color)
    rocket.redRange = 0.5 # how much the colors can vary in each color
    rocket.greenRange = 0.5
    rocket.blueRange = 0.5
    rocket.name = "rocket"

    # Flare particles emitted from the rocket as it flies
    flare = CAEmitterCell.emitterCell
    flare.contents = img
    flare.emissionLongitude = Math::PI
    flare.scale = 0.4 # smaller
    flare.velocity = 100
    flare.birthRate = 45 # quite a few of them
    flare.lifetime = 1.5
    flare.yAcceleration = 200 # going down (positive y direction) faster
    flare.emissionRange = Math::PI / 8
    flare.alphaSpeed = -0.8 # get more translucent
    flare.scaleSpeed = -0.1
    flare.scaleRange = 0.05 # range that the size will vary
    flare.beginTime = 0.01 # start shortly after the rocket fires
    flare.duration = 0.7 # length of animation

    # The particles that make up the explosion
    firework = CAEmitterCell.emitterCell
    firework.contents = img
    firework.birthRate = 9999 # tons of them
    firework.scale = 0.6 # a bit smaller
    firework.velocity = 130
    firework.lifetime = 2
    firework.alphaSpeed = -0.2 # speed they are going invisible
    firework.yAcceleration = -80
    firework.beginTime = 1.5 # start just as the rocket is dying
    firework.duration = 0.1 # animation time
    firework.emissionRange = 2 * Math::PI # they can be released in any direction on entire circle
    firework.scaleSpeed = -0.1 # speed they are getting smaller
    firework.spin = 2 # the images spin
    firework.name="firework"

    # preSpark is an invisible particle used to later emit the spark
    preSpark = CAEmitterCell.emitterCell
    preSpark.birthRate = 80
    preSpark.velocity = firework.velocity * 0.70
    preSpark.lifetime = 1.7
    preSpark.yAcceleration = firework.yAcceleration * 0.85
    preSpark.beginTime = firework.beginTime - 0.2 # begin after the initial firework explosion so not as far out as the whole firework
    preSpark.emissionRange = firework.emissionRange # whole circle of directions
    preSpark.greenSpeed = 100 # these make the children's images become whiter
    preSpark.blueSpeed = 100
    preSpark.redSpeed = 100
    preSpark.name = "preSpark"

    # The 'sparkle' at the end of a firework
    spark = CAEmitterCell.emitterCell
    spark.contents = img
    spark.lifetime = 0.05 # short sparkle
    spark.yAcceleration = -250
    spark.beginTime = 0.8
    spark.scale = 0.4
    spark.birthRate = 25

    preSpark.emitterCells = [spark]
    rocket.emitterCells = [flare, firework, preSpark]
    mortar.emitterCells = [rocket]

    self.view.layer.addSublayer(mortar)
  end

end