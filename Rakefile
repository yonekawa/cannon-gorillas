# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'joybox'

require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Cannon Gorillas'
  app.version = '0.0.1'
  app.identifier = 'jp.mog2dev.game.gorillas'
  app.interface_orientations = [:landscape_left]
  app.deployment_target = '5.0'
  app.device_family = :iphone

  # FIXME: Joybox does not contains CocosDenshion.
  app.vendor_project  'vendor/CocosDenshion', :static
end
