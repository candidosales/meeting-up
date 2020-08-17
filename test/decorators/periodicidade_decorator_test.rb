# coding: utf-8
require 'test_helper'

class PeriodicidadeDecoratorTest < ActiveSupport::TestCase
  def setup
    @periodicidade = Periodicidade.new.extend PeriodicidadeDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
