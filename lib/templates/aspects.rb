# frozen_string_literal: true

require 'aquarium'
require "#{Rails.root}/lib/bdd_generator_parser.rb"

include Aquarium::Aspects

Rails.application.eager_load!

# Get Rails models and controllers classes
controllers = ApplicationController.subclasses
models = ApplicationRecord.subclasses
data = []

if Rails.env.development?
  Aspect.new(:around,
             calls_to: :all_methods,
             for_types: controllers,
             method_options: :exclude_ancestor_methods) do |jp, obj, *_args|
    
    models.each do |m|
      m.all.each do |r|
        data << "#{m} #{r.id} #{r.to_json}\n" 
      end
    end

    request_controller = obj.params[:controller]
    request_action = obj.params[:action]
    body = obj.params
    headers = obj.request.headers['Authorization'] ? {Authorization: obj.request.headers['Authorization']} : {}
    fullpath = obj.request.fullpath
    method = obj.request.method
    result = jp.proceed
    status = obj.status
    
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "\n\nnew_test:\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "controller: #{request_controller}\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "action: #{request_action}\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "body: #{body.to_json}\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "headers: #{headers.to_json}\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "path: #{fullpath}\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "method: #{method}\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "data:\n" }
    data.uniq.each { |d| File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write d } }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "status: #{status}\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "retorno:\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "#{result}\n" }
    data = []

    result
  end
end
