# frozen_string_literal: true

Given(/^There is an instance of (.*?) with id (.*?) and params: (.*?)$/) do |obj, id, params|
  if !eval(obj).find_by_id(id)
    o = eval(obj).new(JSON.parse(params))
    o.save(:validate => false)

  end
end

When(/^the client requests with (GET|POST|PUT|DELETE|PATCH) (.*?), body: (.*?), headers: (.*?)$/) do |request_type, path, params, headers|
  if JSON.parse(headers)['Authorization']
    header 'Authorization', JSON.parse(headers)['Authorization']
  end

  case request_type
  when 'GET'
    get path, JSON.parse(params)
  when 'POST'
    post path, JSON.parse(params)
  when 'PUT'
    put path, JSON.parse(params)
  when 'DELETE'
    delete path, JSON.parse(params)
  when 'PATCH'
    patch path, JSON.parse(params)
  end
end

Then(/^the response status should be (.*?)$/) do |status|
  expect(last_response.status).to eq status.to_i
rescue RSpec::Expectations::ExpectationNotMetError => e
  puts 'Response body:'
  puts last_response.body
  raise e
end

And(/^The JSON response should be (.*?)$/) do |value|
  def remove_key(obj, key)
    if obj.respond_to?(:key?) && obj.key?(key)
      obj.delete(key)
    elsif obj.respond_to?(:each)
      obj.each { |a| remove_key(a, key) }
    end
  end
  expected_json = JSON.parse(value)
  remove_key(expected_json, "id")
  remove_key(expected_json, "created_at")
  remove_key(expected_json, "updated_at")
  remove_key(expected_json, "password_digest")
  remove_key(expected_json, "token")

  true_json = JSON.parse(last_response.body)
  remove_key(true_json, "id")
  remove_key(true_json, "created_at")
  remove_key(true_json, "updated_at")
  remove_key(true_json, "password_digest")
  remove_key(true_json, "token")

  expect(true_json).to eq expected_json
end
