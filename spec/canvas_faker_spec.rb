require "spec_helper"
require "support/http_party"

class MockApi

  def initialze(accounts)
    @accounts = accounts
  end

  def all_accounts
    @accounts
  end
end

class MockCli
  def initialize(response)
    @resp = response
  end

  def ask
    @resp
  end
end

describe CanvasFaker do
  it "has a version number" do
    expect(CanvasFaker::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end

  it "gets all accounts" do
    asdf = CanvasFaker::Functionality.new(nil,nil)
    answer = 2;
    accounts = {
      [
        id: 123,
        name: "Tester Course 1"
      ],
      [
        id: 456,
        name: "Tester Course 2"
      ],
      [
        id: 789,
        name: "Tester Course 3"
      ]
    }

    asdf.class_variable_set :@api, MockApi.new(accounts)


    expect(asdf.get_account_id).to eq(789)
  end

  it "should create course" do
    # If course already exists return existing course
    # If the course exists, still be able to create new course
    # If course does not exist, create new course
  end

  it "should delete a course" do
  end

  it "should should create users" do
  end

end
