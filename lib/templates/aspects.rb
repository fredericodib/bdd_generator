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

  Aspect.new(:around,
             calls_to: [:find, :second, :last, :where, /ll$/],
             for_types: models,
             method_options: %i[class]) do |jp, obj, *_args|
    result = jp.proceed

    if result.class != obj
      result.each { |r| data << "#{obj} #{r.id} #{r.to_json}\n" }
    else
      data << "#{obj} #{result.id} #{result.to_json}\n"
    end
    result
  end

  Aspect.new(:around,
             calls_to: %i[save update],
             for_types: models) do |jp, obj, *_args|
    obj.class.all
    result = jp.proceed
    # if result.class != obj
    #   result.each { |r| data << "#{obj} #{r.id} #{r.to_json}\n" }
    # else
    #   data << "#{obj} #{result.id} #{result.to_json}\n"
    # end
    result
  end
end
