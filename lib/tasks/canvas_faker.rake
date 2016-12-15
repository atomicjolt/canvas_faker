require "dotenv"
require "canvas_faker"

Dotenv.load

namespace :canvas_faker do
  desc "Set up test course (new course, users, lti-tool)"
  task :setup_course do
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    faker.setup_course
  end

  desc "Delete a course from your canvas account"
  task :delete_course do
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    # maybe have functionality of deleting by ARG[1] = course_id
    # and passing the course_id in?
    faker.delete_course
  end
end
