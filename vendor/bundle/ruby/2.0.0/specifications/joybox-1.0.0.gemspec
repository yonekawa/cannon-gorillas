# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "joybox"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Juan Jos\u{e9} Karam"]
  s.date = "2013-05-13"
  s.description = "    A Cocos2D & Box2D DSL for RubyMotion\n"
  s.email = "juanjokaram@gmail.com"
  s.executables = ["joybox"]
  s.files = ["bin/joybox"]
  s.homepage = "http://joybox.io"
  s.licenses = ["MIT"]
  s.post_install_message = "  ** Joybox 1.0.0 **\n\n    * Added REPL Support for iOS and OSX :D\n      * NOTE: If the iOS simulator starts on landscape orientation, please rotate and return it.\n              (cmd + => and cmd + <=)\n    * Added REPL Example Template. Use 'motion create --template=joybox-ios-example-repl <name>' or\n      'motion create --template=joybox-osx-example-repl <name>'\n    * IMPORTANT: Typo fix in World class (Joybox, Box2D and Website), changing to continuous_physics the configuration, thank you David Czarnecki!\n    * IMPORTANT: Typo fix in Macros, changing jbpLenght to jpbLength, thank you David Czarnecki!\n    * Added: Clear extra lines in iOS Template. Thank you Willrax!\n    * Added: Examples iPhone 5 support\n    * Added: iOS Template iPhone 5 support\n    * Joybox is stopping the madness! Thanks all for your support!\n\n                        0\n                       101\n                      01010\n                     1010101\n                    010101010\n                   10101010101\n                  0101010101010\n                 101010101010101\n                01010101010101010\n               1010101010101010101\n              010101010101010101010\n             1                     1\n            010                   010\n           10101                 10101\n          0101010               0101010\n         101010101             101010101\n        01010101010           01010101010\n       1010101010101         1010101010101\n      010101010101010       010101010101010\n     10101010101010101     10101010101010101\n    0101010101010101010   0101010101010101010\n   1010101010101010101011101010101010101010101\n\n"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.0"
  s.summary = "A Cocos2D & Box2D DSL for RubyMotion"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
