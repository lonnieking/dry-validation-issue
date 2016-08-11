require 'dry-validation'

class Person
  attr_reader :name

  def initialize(name:)
    @name = name
  end

  def errors
    validation_schema.call(name: name).messages
  end

  private

  def validation_schema
    Dry::Validation.Schema do
      configure do
        config.messages_file = File.expand_path(File.dirname(__FILE__) + '/validation_messages.yml')
        predicates(Person::Predicates)
      end

      required(:name).value :long_enough?
    end
  end

  module Predicates
    include Dry::Logic::Predicates

    # This one works fine.
    # predicate(:long_enough?) { |x| x.length > 5 }

    # This one should work, but doesn't.
    predicate(:long_enough?) { |locale| locale.length > 5 }
  end
end
