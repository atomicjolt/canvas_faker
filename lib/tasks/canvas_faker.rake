require "dotenv"
require "canvas_faker"

Dotenv.load

namespace :canvas_faker do
  desc "Set up test course (Interactive) (new course, users, lti-tool)"
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
    faker.delete_course
  end

  desc "Delete a course from your canvas account by course_id"
  task :delete_course_by_id do
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    faker.delete_course_by_id(ARGV[1])
  end

  desc "Add assignments to a course, param (course_id)"
  task :add_assignments_to_course do
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    faker.add_assignments_to_course(ARGV[1])
  end

  desc "get quizzes for course (course_id)"
  task :get_quizzes do
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    faker.get_quizzes(ARGV[1])
  end


end