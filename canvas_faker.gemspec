# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "canvas_faker/version"

Gem::Specification.new do |spec|
  spec.name          = "canvas_faker"
  spec.version       = CanvasFaker::VERSION
  spec.authors       = ["Justin Ball", "Benjamin Call"]
  spec.email         = ["justin.ball@atomicjolt.com"]

  spec.summary       = "Utility for setting up courses and users in Instructure Canvas."
  spec.description   = "Atomic Jolt found that we frequently needed to setup courses with " \
                       "users to test. This gem handles that requirement."
  spec.homepage      = "https://github.com/atomicjolt/canvas_faker"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "lms-api"
  spec.add_dependency "highline"
  spec.add_dependency "faker"
  spec.add_dependency "dotenv"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug", "~> 8.2", ">= 8.2.4"

end
