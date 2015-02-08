Kernel.load 'lib/trebbiatrice/version.rb'

Gem::Specification.new do |s|
  s.name          = 'trebbiatrice'
  s.version       = Trebbiatrice::VERSION
  s.author        = 'Giovanni Capuano'
  s.email         = 'webmaster@giovannicapuano.net'
  s.homepage      = 'https://github.com/mozestudio/Trebbiatrice'
  s.platform      = Gem::Platform::RUBY
  s.summary       = "Track the time on Harvest automatically watching what you're working on."
  s.description   = "Track the time on Harvest automatically watching what you're working on. So you've just to work without thinking about starting and stopping the tracker."
  s.license       = 'WTFPL'

  s.files         = `git ls-files -z`.split("\0")
  s.require_path  = 'lib'
  s.executables   = 'trebbiatrice'

  s.add_dependency 'harvested', '~> 3.1'
end
