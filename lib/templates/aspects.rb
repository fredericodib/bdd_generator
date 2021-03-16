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

    result = jp.proceed
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "\n\nnew_test:\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "controller: #{obj.params[:controller]}\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "action: #{obj.params[:action]}\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "params: #{obj.params.to_json}\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "path: #{obj.request.fullpath}\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "method: #{obj.request.method}\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "data:\n" }
    data.uniq.each { |d| File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write d } }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "status: #{obj.status}\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "retorno:\n" }
    File.open('features/bdd_generator_logs.txt', 'a') { |f| f.write "#{result}\n" }
    data = []

    result
  end
end
