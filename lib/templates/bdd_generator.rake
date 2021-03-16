# frozen_string_literal: true

namespace :bdd_generator do
  desc 'This task is called by the Heroku scheduler add-on'
  task build: :environment do
    BddGeneratorParser.build
  end
end
