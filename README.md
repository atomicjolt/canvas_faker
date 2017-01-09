# CanvasFaker

This gem generates courses, students and other data for an Instructure Canvas instance which
will help save time if you need to test

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'canvas_faker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install canvas_faker

Rename .env.example to .env and provide a Canvas URL and an API Token


## Usage

Run one of the following rake tasks.

### Add assignments to a course
Adds a list of dummy assignments to a course, pass the course id in as a command line argument
```rake canvas_faker:add_assignments_to_course[course_id]```
### add students to course (account_id, course_id)
```rake canvas_faker:add_students_to_course```
### Delete a course from your canvas account
```rake canvas_faker:delete_course```
### Delete a course from your canvas account by course_id
```rake canvas_faker:delete_course_by_id```
### get quizzes for course (course_id)
```rake canvas_faker:get_quizzes```
### Set up test course (Interactive) (new course, users, lti-tool)
```rake canvas_faker:setup_course```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version,
update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git
tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/atomicjolt/canvas_faker.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

