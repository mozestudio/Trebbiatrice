Kernel.load 'lib/trebbiatrice/version.rb'

Gem::Specification.new do |s|
  s.name          = 'trebbiatrice'
  s.version       = Trebbiatrice::VERSION
  s.author        = 'Giovanni Capuano'
  s.email         = 'webmaster@giovannicapuano.net'
  s.homepage      = 'http://www.giovannicapuano.net'
  s.platform      = Gem::Platform::RUBY
  s.summary       = 'RESTful gem for wrapping Pigro\'s APIs'
  s.description   = 'RESTful wrapper gem for Pigro\'s APIs'
  s.license       = 'WTFPL'

  s.files         = `git ls-files -z`.split("\0")
  s.require_path  = 'lib'
  s.executables   = 'trebbiatrice'

  s.add_dependency 'harvested', '~> 3.1'
end
