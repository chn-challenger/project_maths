require './models/expression'

class Fraction
  attr_accessor :integer, :numerator, :denominator

  def initialize(integer, numerator, denominator)
    @integer = integer
    @numerator = numerator
    @denominator = denominator
  end

  def simplify
    _divide_out_gcd
    _reduce_topheavy
    self
  end

  def ==(fraction)
    (integer == fraction.integer) && (numerator == fraction.numerator) &&
      (denominator == fraction.denominator)
  end

  def >(fraction)
    self_topheavy = mixed_to_topheavy
    fraction_topheavy = fraction.mixed_to_topheavy
    self_topheavy.numerator.to_f / self_topheavy.denominator > fraction_topheavy.numerator.to_f / fraction_topheavy.denominator
  end

  def <(fraction)
    !(self > fraction) && !same_value?(fraction)
  end

  def same_value?(fraction)
    simplify
    fraction.simplify
    self == fraction
  end

  def mixed_to_topheavy
    new_numerator = numerator + integer * denominator
    self.class.new(0, new_numerator, denominator)
  end

  def topheavy_to_mixed
    new_integer = numerator / denominator
    new_numerator = numerator - new_integer * denominator
    self.class.new(new_integer, new_numerator, denominator)
  end

  def +(fraction)
    result_int_part = integer + fraction.integer
    result_denominator = denominator.lcm(fraction.denominator)
    result_numerator = numerator * (result_denominator / denominator) +
                       fraction.numerator * (result_denominator / fraction.denominator)
    self.class.new(result_int_part, result_numerator, result_denominator).simplify
  end

  def -(fraction)
    fraction = self.class.new(-1 * fraction.integer, -1 * fraction.numerator, fraction.denominator)
    self + fraction
  end

  def *(fraction)
    fraction1 = simplify.mixed_to_topheavy
    fraction2 = fraction.simplify.mixed_to_topheavy
    result_numerator = fraction1.numerator * fraction2.numerator
    result_denominator = fraction1.denominator * fraction2.denominator
    self.class.new(0, result_numerator, result_denominator).simplify
  end

  def /(fraction)
    fraction1 = simplify.mixed_to_topheavy
    fraction2 = fraction.simplify.mixed_to_topheavy
    fraction = self.class.new(0, fraction2.denominator, fraction2.numerator)
    fraction1 * fraction
  end

  def self.random(parameters = {})
    _set_default(parameters)
    integer = rand(0..parameters[:max_integer_value])
    denominator = rand(2..parameters[:max_fraction_value])
    numerator = rand(1...parameters[:max_fraction_value])
    new_fraction = new(integer, numerator, denominator).simplify
    if new_fraction.numerator == 0
      return random(parameters)
    else
      return new_fraction
    end
  end

  def self.generate_question_with_latex(parameters = {})
    latex(generate_question(parameters))
  end

  def self.generate_question(parameters = {})
    _set_default(parameters)
    operation = parameters[:operations].sample
    return _generate_addition(parameters) if operation == :add
    return _generate_subtraction(parameters) if operation == :sbt
    return _generate_multiplication(parameters) if operation == :mtp
    return _generate_division(parameters) if operation == :div
    nil
  end

  def self.latex(generated_question)
    question_latex = generated_question[:question].flatex
    solution_latex = question_latex + '=' + generated_question[:solution].flatex
    { question_latex: question_latex, solution_latex: solution_latex }
  end

  private

  def _reduce_topheavy
    extra_int_part = numerator / denominator
    @integer += extra_int_part
    @numerator -= denominator * extra_int_part
  end

  def _divide_out_gcd
    gcd = numerator.gcd(denominator)
    @numerator /= gcd
    @denominator /= gcd
  end

  def self._set_default(parameters)
    parameters[:operations] ||= [:add, :sbt, :mtp, :div]
    parameters[:max_integer_value] ||= 9
    parameters[:max_fraction_value] ||= 12
  end

  def self._generate_addition(parameters)
    fraction_1 = random(parameters)
    fraction_2 = random(parameters)
    question = Expression.new([Step.new(nil, fraction_1), Step.new(:add, fraction_2)])
    solution = Expression.new([Step.new(nil, fraction_1 + fraction_2)])
    { question: question, solution: solution }
  end

  def self._generate_subtraction(parameters)
    fraction_1 = random(parameters)
    fraction_2 = random(parameters)
    fraction_1, fraction_2 = fraction_2, fraction_1 if fraction_2 > fraction_1
    question = Expression.new([Step.new(nil, fraction_1), Step.new(:sbt, fraction_2)])
    solution = Expression.new([Step.new(nil, fraction_1 - fraction_2)])
    { question: question, solution: solution }
  end

  def self._generate_multiplication(parameters)
    fraction_1 = random(parameters)
    fraction_2 = random(parameters)
    question = Expression.new([Step.new(nil, fraction_1), Step.new(:mtp, fraction_2)])
    solution = Expression.new([Step.new(nil, fraction_1 * fraction_2)])
    { question: question, solution: solution }
  end

  def self._generate_division(parameters)
    fraction_1 = random(parameters)
    fraction_2 = random(parameters)
    question = Expression.new([Step.new(nil, fraction_1), Step.new(:div, fraction_2)])
    solution = Expression.new([Step.new(nil, fraction_1 / fraction_2)])
    { question: question, solution: solution }
  end

  # def self._addition(integer_range,fraction_range)
  #   fraction1 = self.random(integer_range,fraction_range)
  #   fraction2 = self.random(integer_range,fraction_range)
  #   {operation:'add',fraction1:fraction1,fraction2:fraction2,
  #     solution:fraction1.add(fraction2)}
  # end
  #
  # def self._subtraction(integer_range,fraction_range)
  #   fraction1 = self.random(integer_range,fraction_range)
  #   while true
  #     fraction2 = self.random(integer_range,fraction_range)
  #     break if fraction2 < fraction1
  #   end
  #   {operation:'subtract',fraction1:fraction1,fraction2:fraction2,
  #     solution:fraction1.subtract(fraction2)}
  # end
  #
  # def self._multiplication(integer_range,fraction_range)
  #   fraction1 = self.random((integer_range*0.6).to_i,(fraction_range*0.8).to_i)
  #   fraction2 = self.random((integer_range*0.6).to_i,(fraction_range*0.8).to_i)
  #   {operation:'multiply',fraction1:fraction1,fraction2:fraction2,
  #     solution:fraction1.multiply(fraction2)}
  # end
  #
  # def self._division(integer_range,fraction_range)
  #   fraction1 = self.random((integer_range*0.6).to_i,(fraction_range*0.8).to_i)
  #   fraction2 = self.random((integer_range*0.6).to_i,(fraction_range*0.8).to_i)
  #   {operation:'divide',fraction1:fraction1,fraction2:fraction2,
  #     solution:fraction1.divide(fraction2)}
  # end
end

# def generate_solution
#
# end

# def self.random(integer_range=10,fraction_range=10)
#   integer = rand(0..integer_range)
#   denominator = rand(2..fraction_range)
#   numerator = rand(1...denominator)
#   Fraction.new(integer,numerator,denominator).simplify
# end
#
# def self.question(operation='add',integer_range=10,fraction_range=10)
#   return self._addition(integer_range,fraction_range) if operation == 'add'
#   return self._subtraction(integer_range,fraction_range) if operation == 'subtract'
#   return self._multiplication(integer_range,fraction_range) if operation == 'multiply'
#   return self._division(integer_range,fraction_range) if operation == 'divide'
# end
#
# def self.worksheet_questions(number_of_questions=1,operations=['add'],
#     integer_range=10,fraction_range=10)
#   questions = []
#   number_of_questions.times do
#     operation = operations[rand(0..operations.length-1)]
#     questions << self.question(operation,integer_range,fraction_range)
#   end
#   questions
# end
