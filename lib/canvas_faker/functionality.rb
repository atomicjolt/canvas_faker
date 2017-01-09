require "highline"
require "lms_api"
require "faker"
require "byebug"

module CanvasFaker

  class Functionality

    def initialize(canvas_url, token, tools = [])
      @api = LMS::Canvas.new(canvas_url, token)
      @canvas_url = canvas_url
      @tools = tools
      @cli ||= HighLine.new
    end

    # def create_course_100(account_id)
    #   (1..100).map.with_index do |i, index|
    #     course_name = "Sandbox #{i}"
    #     payload = {
    #       course: {
    #         name: course_name,
    #         # sis_course_id: course_id,
    #       }
    #     }
    #     course = @api.proxy(
    #       "CREATE_NEW_COURSE",
    #       { account_id: account_id },
    #       payload
    #     )
    #     puts "#{@canvas_url}/courses/#{course['id']}"
    #     instructor = create_instructor(account_id, i)
    #     enroll_single_user_in_course(instructor, course["id"])
    #   end
    #   puts "Completed making 100 courses with 1 instructor each"
    # end

    def setup_course
      account_id = get_account_id
      courses = course_list(account_id)
      course_id = create_course(account_id, courses)["id"]
      students = create_users(account_id, custom = nil, base_email = nil, prefix = nil)
      enroll_users_in_course(students, course_id)
      make_assignments_in_course(course_id)
      install_lti_tool_to_course(course_id)
    end

    def add_students_to_course(account_id, course_id)
      num = @cli.ask "Press 1 for auto generated students and 2 for custom"
      custom = false
      email_base = nil
      if num == "2"
        email_base = @cli.ask "What email to use (ex.. ryan.jones@example.com)"
        prefix = @cli.ask "What do you want the custom email prefix to be?"
        custom = true
      end
      students = create_users(account_id, custom, email_base, prefix)
      enroll_users_in_course(students, course_id)
    end

    # def add_custom_students_to_course(account_id, course_id)
    #   student = custom_students(account_id)
    #   enroll_single_user_in_course(student, course_id)
    # end

    def delete_course
      account_id = get_account_id
      courses = course_list(account_id)
      course = @cli.ask("Delete which course? ex.. 2", Integer)
      @api.proxy(
        "CONCLUDE_COURSE",
        { id: courses[course]["id"],
          event: "delete"
        }
      )
      puts "Deleted #{courses[course]['name']}"
    end

    def get_quizzes(course_id)
      a = @api.proxy(
        "LIST_QUIZZES_IN_COURSE",
        { course_id: course_id }
      )
      puts "QUIZ::: #{a}"
    end

    def delete_course_by_id(course_id)
      @api.proxy(
        "CONCLUDE_COURSE",
        { id: course_id,
          event: "delete"
        }
      )
      puts "Deleted course with id: #{course_id}"
    end

    def make_assignments_in_course(course_id)
      num_of_assignments = @cli.ask("How many assignments?", Integer)
      create_assignments_in_course(course_id, num_of_assignments)
    end

    private

    def create_assignments_in_course(course_id, num_of_assignments)
      (1..num_of_assignments).map do
        food = Faker::Pokemon.name
        payload = {
          assignment: {
            name: "All about #{food}",
            published: true
          }
        }
        @api.proxy(
          "CREATE_ASSIGNMENT",
          { course_id: course_id },
          payload
        ).tap { |assignment| puts "Creating #{assignment['name']} in your course." }
      end
      puts "Added #{num_of_assignments} assignments to your course"
    end

    def course_list(account_id)
      courses = @api.proxy(
        "LIST_ACTIVE_COURSES_IN_ACCOUNT",
        { account_id: account_id }
      )
      courses.each_with_index do |course, index|
        puts "#{index}. #{course['name']}, id: (#{course['id']})"
      end
      courses
    end

    def get_account_id
      accounts = @api.all_accounts # gets the accounts
      accounts.each_with_index do |account, index|
        puts "#{index}. #{account['name']}"
      end
      answer = @cli.ask("Which account? ex.. 2", Integer)
      accounts[answer]["id"]
    end

    # Returns true or false
    def should_create_course?(existing_course_names, course_name)
      if existing_course_names.include?(course_name)
        use_old_course = @cli.ask "That course already exists, want to use it? [y/n]"
        if use_old_course == "y" || use_old_course == "yes"
          return false
        end
        return true
      end
      return true
    end

    def create_course(account_id, courses)
      existing_course_names = courses.map { |course| course["name"] }
      course_name = @cli.ask "Name your new course."
      if should_create_course?(existing_course_names, course_name)
        payload = {
          course: {
            name: course_name,
            # sis_course_id: course_id,
          }
        }
        course = @api.proxy(
          "CREATE_NEW_COURSE",
          { account_id: account_id },
          payload
        )
        puts "#{@canvas_url}/courses/#{course['id']}"
        course
      else
        index = existing_course_names.find_index("#{course_name}")
        courses[index]
      end
    end

    # def create_instructor(account_id, i)
    #   email = "au.instructors+#{i}@gmail.com"
    #   user_first_name = "Instructor"
    #   user_last_name = "#{i}"

    #   payload = {
    #     user: {
    #       name: "#{user_first_name} #{user_last_name}",
    #       short_name: user_first_name,
    #       sortable_name: "#{user_last_name}, #{user_first_name}",
    #       terms_of_use: true,
    #       skip_registration: true,
    #       avatar: {
    #         url: Faker::Avatar.image
    #       }
    #     },
    #     pseudonym: {
    #       unique_id: "#{email}",
    #       password: "training"
    #     }
    #   }
    #   @api.proxy(
    #     "CREATE_USER",
    #     { account_id: account_id },
    #     payload
    #   )
    # end

    def create_users(account_id, custom, base_email, prefix)
      num_students = @cli.ask(
        "How many students do you want in your course?",
        Integer
      )
      # students = []
      (1..num_students).map.with_index do |num, index|
        user_first_name = Faker::Name.first_name
        user_last_name = Faker::Name.last_name
        full_name = "#{user_first_name}#{user_last_name}"
         if base_email == nil
          base_email = "testemail@example.com"
         end
        email_pieces = base_email.split('@')
        custom_email = "#{email_pieces[0]}+#{prefix}#{index}@#{email_pieces[1]}"
        email = custom ? custom_email : Faker::Internet.safe_email(full_name)
        payload = {
          user: {
            name: "#{user_first_name} #{user_last_name}",
            short_name: user_first_name,
            sortable_name: "#{user_last_name}, #{user_first_name}",
            terms_of_use: true,
            skip_registration: true,
            avatar: {
              url: Faker::Avatar.image
            }
          },
          pseudonym: {
            unique_id: "#{email}",
            password: "password"
          }
        }
        student = @api.proxy(
          "CREATE_USER",
          { account_id: account_id },
          payload
        ).tap { |stud| puts "#{stud['name']} creating. Password: password" }
        # students.push(student)
      end
      # students
    end

    # def enroll_single_user_in_course(instructor, course_id)
    #   payload = {
    #     enrollment: {
    #       user_id: instructor["id"],
    #       type: "TeacherEnrollment",
    #       enrollment_state: "active"
    #     }
    #   }
    #   @api.proxy(
    #     "ENROLL_USER_COURSES",
    #     { course_id: course_id },
    #     payload
    #   )
    #   puts "Enrolled #{instructor['name']} into your course_id #{course_id}"
    # end

    def enroll_users_in_course(students, course_id)
      students.each do |student|
        payload = {
          enrollment: {
            user_id: student["id"],
            type: "StudentEnrollment",
            enrollment_state: "active"
          }
        }
        @api.proxy(
          "ENROLL_USER_COURSES",
          { course_id: course_id },
          payload
        )
        puts "Enrolled #{student['name']} into your course_id #{course_id}"
      end
    end

    def install_lti_tool_to_course(course_id)
      return if @tools.empty?
      # Taken from canvas documentation, below.
      # https://canvas.instructure.com/doc/api/external_tools.html
      @tools.each_with_index do |tool, index|
        puts "#{index}. #{tool[:app][:lti_key]}"
      end
      tool_index =
        @cli.ask("Which tool do you want to add to your course?", Integer)
      tool = tools[tool_index]
      payload = {
        name: "#{tool[:app][:lti_key]}",
        privacy_level: "public",
        consumer_key: "#{tool[:app][:lti_key]}",
        shared_secret: "#{tool[:app][:lti_secret]}",
        config_type: "by_xml",
        config_xml: "#{tool[:config]}"
      }
      @api.proxy(
        "CREATE_EXTERNAL_TOOL_COURSES",
        { course_id: course_id },
        payload
      )
    end
  end
end
