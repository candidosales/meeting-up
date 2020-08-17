# coding: utf-8
require 'test_helper'

class ReuniaoDecoratorTest < ActiveSupport::TestCase
  def setup
    @reuniao = Reuniao.new.extend ReuniaoDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
