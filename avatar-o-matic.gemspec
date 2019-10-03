Gem::Specification.new do |s|
  s.required_ruby_version = '>= 2.1.3'
  s.name        = 'avatar-o-matic'
  s.version     = '0.0.2'
  s.date        = '2016-01-07'
  s.summary     = "User avatar generator"
  s.description = "Generate random avatar images for your tests"
  s.authors     = ["Gunnar Hansson", "Avidity"]
  s.email       = 'code@avidiy.se'
  s.files       = Dir.glob("lib/**/*.rb")
  s.homepage    = 'http://github.com/avidity/avatar-o-matic'
  s.license     = 'MIT'

  s.files       = Dir["{data,lib,spec}/**/*"]

  s.add_dependency 'mini_magick', '>=4.9.5'

  s.add_development_dependency 'rspec', '3.8'
end
