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

  desc "Delete a course from your canvas account by (course_id)"
  task :delete_course_by_id, [:a1] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    faker.delete_course_by_id(args[:a1])
  end

  desc "Add assignments to a course, param (course_id)"
  task :add_assignments_to_course, [:a1] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    faker.add_assignments_to_course(args[:a1])
  end

  desc "get quizzes for course (course_id)"
  task :get_quizzes, [:a1] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    faker.get_quizzes(args[:a1].to_i)
  end

  desc "add auto-generated or custom students to course (account_id, course_id)"
  task :add_students_to_course, [:a1, :a2] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    faker.add_students_to_course(args[:a1].to_i, args[:a2].to_i)
  end
end
