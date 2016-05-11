# require './models/expression'
# require 'capybara/rspec'
#
# feature 'Integration test' do
#
#   num_1 = NumExp.new(5)
#   num_2 = NumExp.new(7)
#   num_3 = NumExp.new(11)
#   step_1 = Step.new(nil,num_1)
#   step_2 = Step.new(:add,num_2)
#   step_3 = Step.new(:mtp,num_3)
# 	expression = Expression.new([step_1,step_2,step_3])
#
# 	scenario 'can expand add and mtp by num exp valued steps' do
#     expected_ms_exp = MtpFormSumExp.new([
#       Step.new(nil,
#         MtpFormExp.new([
#           Step.new(nil,NumExp.new(5)),
#           Step.new(:mtp,NumExp.new(11))
#         ])
#       ),
#       Step.new(:add,
#         MtpFormExp.new([
#           Step.new(nil,NumExp.new(7)),
#           Step.new(:mtp,NumExp.new(11))
#         ])
#       )
#     ])
#     result = expression.expand_to_ms
# 		expect(result).to eq expected_ms_exp
# 	end
#
# end
