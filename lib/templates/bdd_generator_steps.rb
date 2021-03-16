# frozen_string_literal: true

Given(/^There is an instance of (.*?) with id (.*?) and params: (.*?)$/) do |obj, id, params|
  !eval(obj).find_by_id(id) && eval(obj).create(JSON.parse(params))
  # "!#{obj}.find_by_id(#{r.id}) && #{obj}.create(JSON.parse('#{r.to_json}'))\n"
end

When(/^the client requests with (GET|POST|PUT|DELETE|PATCH) (.*?), params: (.*?)$/) do |request_type, path, params|
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
      r = nil
      obj.find { |*a| r = remove_key(a.last, key) }
      r
    end
  end
  expected_json = JSON.parse(value)
  remove_key(expected_json, 'id')
  remove_key(expected_json, 'created_at')
  remove_key(expected_json, 'updated_at')
  # expected_json.each { |h| h.delete('created_at') && h.delete('updated_at') }
  # expected_json.delete('created_at')
  # expected_json.delete('updated_at')

  true_json = JSON.parse(last_response.body)
  remove_key(true_json, 'id')
  remove_key(true_json, 'created_at')
  remove_key(true_json, 'updated_at')
  # true_json.each { |h| h.delete('created_at') && h.delete('updated_at') }
  # true_json.delete('created_at')
  # true_json.delete('updated_at')

  # if last_response.status == 201
  #   true_json.each { |h| h.delete('id') }
  #   true_json.delete('id')

  #   expected_json.each { |h| h.delete('id') }
  #   expected_json.delete('id')
  # end

  expect(true_json).to eq expected_json
end
