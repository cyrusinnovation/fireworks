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
    mortar.emitterPosition = CGPointMake(160, 420)
    mortar.renderMode = KCAEmitterLayerAdditive

    # Invisible particle representing the rocket before the explosion
    rocket = CAEmitterCell.emitterCell.retain
    rocket.emissionLongitude = (3 * Math::PI) / 2
    rocket.emissionLatitude = 0
    rocket.lifetime = 1.6
    rocket.birthRate = 4
    rocket.velocity = 400
    rocket.velocityRange = 100
    rocket.yAcceleration = 250
    rocket.emissionRange = Math::PI / 4
    color = UIColor.colorWithRed(0.5, green:0.5, blue:0.5, alpha:0.5).CGColor
    rocket.color = color
    CGColorRelease(color)
    rocket.redRange = 0.5
    rocket.greenRange = 0.5
    rocket.blueRange = 0.5
    rocket.name = "rocket"

    # Flare particles emitted from the rocket as it flies
    flare = CAEmitterCell.emitterCell
    flare.contents = img
    flare.emissionLongitude = Math::PI
    flare.scale = 0.4
    flare.velocity = 100
    flare.birthRate = 45
    flare.lifetime = 1.5
    flare.yAcceleration = 200
    flare.emissionRange = Math::PI / 8
    flare.alphaSpeed = -0.8
    flare.scaleSpeed = -0.1
    flare.scaleRange = 0.05
    flare.beginTime = 0.01
    flare.duration = 0.7

    # The particles that make up the explosion
    firework = CAEmitterCell.emitterCell
    firework.contents = img
    firework.birthRate = 9999
    firework.scale = 0.6
    firework.velocity = 130
    firework.lifetime = 2
    firework.alphaSpeed = -0.2
    firework.yAcceleration = -80
    firework.beginTime = 1.5
    firework.duration = 0.1
    firework.emissionRange = 2 * Math::PI
    firework.scaleSpeed = -0.1
    firework.spin = 2
    firework.name="firework"

    # preSpark is an invisible particle used to later emit the spark
    preSpark = CAEmitterCell.emitterCell
    preSpark.birthRate = 80
    preSpark.velocity = firework.velocity * 0.70
    preSpark.lifetime = 1.7
    preSpark.yAcceleration = firework.yAcceleration * 0.85
    preSpark.beginTime = firework.beginTime - 0.2
    preSpark.emissionRange = firework.emissionRange
    preSpark.greenSpeed = 100
    preSpark.blueSpeed = 100
    preSpark.redSpeed = 100
    preSpark.name = "preSpark"

    # The 'sparkle' at the end of a firework
    spark = CAEmitterCell.emitterCell
    spark.contents = img
    spark.lifetime = 0.05
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