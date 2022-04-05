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

  desc "Delete an assignment from your course by (course_id, assignment_id)"
  task :delete_assignment_by_id, [:a1, :a2] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    faker.delete_assignment_by_id(args[:a1].to_i, args[:a2].to_i)
  end

  desc "Add assignments to a course (course_id)"
  task :add_assignments_to_course, [:a1] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    faker.add_assignments_to_course(args[:a1].to_i)
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

  # desc "get survey results.. (course_id)"
  # task :survey_from_account do |t, args|
  #   faker = CanvasFaker::Functionality.new(
  #     ENV["APP_DEFAULT_CANVAS_URL"],
  #     ENV["CANVAS_TOKEN"]
  #   )
  #   faker.survey_from_account(245)
  # end

  desc "get courses by user_id"
  task :get_courses_user, [:a1] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    results = faker.get_courses_user(args[:a1].to_i)
    reportable_results = results.map { |r| {id: r["id"], account_id: r["account_id"], name: r["name"]}}
    puts reportable_results.to_json
    pp reportable_results
  end

  desc "get courses by account_id"
  task :get_courses_account, [:a1] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    results = faker.get_courses_account(args[:a1].to_i)
    reportable_results = results.map { |r| {id: r["id"], account_id: r["account_id"], name: r["name"]}}
    puts reportable_results.to_json
    pp reportable_results
  end

  desc "create courses in account"
  task :create_account_courses, [:account_id, :num_courses, :course_base_name] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )

    account_id = args[:account_id].to_i
    num_courses = args[:num_courses].to_i
    base_name = args[:course_base_name] || "Test Course"

    (1..num_courses).each do |i|
      course = faker.create_course(args[:account_id], {name: "#{base_name} #{i}"})
      puts "Created course: #{course["id"]} - #{course["name"]}"
    end
  end

  desc "get blueprint courses by account_id"
  task :get_blueprint_courses_account, [:a1] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    results = faker.get_courses_account(args[:a1].to_i)
    blueprint_courses = results.filter {|r| r["blueprint"]}
    reportable_results = blueprint_courses.map { |r| {id: r["id"], account_id: r["account_id"], name: r["name"]}}
    puts reportable_results.to_json
    pp reportable_results
  end

 desc "get non_blueprint courses by account_id"
  task :get_non_blueprint_courses_account, [:a1, :json_only] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    results = faker.get_courses_account(args[:a1].to_i)
    blueprint_courses = results.filter {|r| !r["blueprint"]}
    reportable_results = blueprint_courses.map { |r| {id: r["id"], account_id: r["account_id"], name: r["name"]}}
    puts reportable_results.to_json

    pp reportable_results if(!args[:json_only])
  end

 desc "reset courses"
  task :reset_courses, [:filename] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    content = File.read(args[:filename])
    id_list = JSON.parse(content)
    responses = []
    id_list.each do |id|
      raise "Course id: #{id} must be an integer" if !id.is_a? Integer
      response = faker.reset_course(id)
      responses << response
      puts "Reset: #{id}" if response.code >= 200
    end
  end

 desc "update blueprint associations"
  task :update_blueprint_associations, [:course_id, :ids_to_add_file, :ids_to_remove_file] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )


    ids_to_add = if args[:ids_to_add_file].present?
      JSON.parse(File.read(args[:ids_to_add_file]))
    else
      nil
    end

    ids_to_remove =if args[:ids_to_remove_file].present?
      JSON.parse(File.read(args[:ids_to_remove_file]))
    else
      nil
    end

    faker.update_associated_courses(args[:course_id], ids_to_add || [], ids_to_remove || [])
  end

 desc "sync blueprint course"
  task :sync_blueprint_course, [:course_id] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )

    faker.sync_to_associated_courses(args[:course_id])
  end

  desc "copy content into course (source_course_id, course_id)"
  task :copy_content_to_course, [:a1, :a2] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    faker.copy_content_to_course(args[:a1].to_i, args[:a2].to_i)
  end

  desc "generate page view analytics (course_id)"
  task :create_page_analytics, [:a1] do |t, args|
    faker = CanvasFaker::Functionality.new(
      ENV["APP_DEFAULT_CANVAS_URL"],
      ENV["CANVAS_TOKEN"]
    )
    faker.create_page_analytics(args[:a1].to_i)
  end

end
