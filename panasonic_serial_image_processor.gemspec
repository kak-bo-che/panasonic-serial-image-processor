# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'panasonic_serial_image_processor/version'

Gem::Specification.new do |gem|
  gem.name          = "panasonic_serial_image_processor"
  gem.version       = PanasonicSerialImageProcessor::VERSION
  gem.authors       = ["Troy Ross"]
  gem.email         = ["kak.bo.che@gmail.com"]
  gem.description   = %q{Identify and move files in download directory}
  gem.summary       = %q{Identify and move files uploaded from a panasonic network camera to a subdirectory based on date}
  gem.homepage      = ""

  gem.add_development_dependency 'rake'
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
