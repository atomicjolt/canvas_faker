require "dotenv"

require "canvas_faker"

Dotenv.load

namespace :canvas_faker do
  desc "Set up test course (new course, users, lti-tool)"
  task :setup_course do
    faker = CanvasFaker::Populate.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    faker.setup_course
  end
end
