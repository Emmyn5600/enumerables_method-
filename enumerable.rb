module Enumerable
  def my_each
    return enum_for(:my_each) unless block_given?
    i = 0
    while i < to_a.length
      yield(to_a[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    while i < to_a.length
      yield(to_a[i], i)
      i += 1
    end
    self
  end

  def my_select
    return enum_for(:my_select) unless block_given?

    arr = []
    to_a.my_each { |n| arr.push(n) if yield(n) }
    arr
  end

  def my_all?(param = nil)
    if block_given?
      to_a.my_each { |n| return false unless yield(n) }
    elsif param.nil?
      to_a.my_each { |n| return false if !n || n.nil? }
    elsif !param.nil? && (param.is_a? Class)
      to_a.my_each { |n| return false unless [n.class, n.class.superclass, n.class.superclass].include?(param) }
    elsif !param.nil? && (param.is_a? Regexp)
      to_a.my_each { |n| return false unless n.match(param) }
    else
      to_a.my_each { |n| return false unless n == param }
    end
    true
  end

  def my_any?(param = nil)
    if block_given?
      to_a.my_each { |n| return true if yield(n) }
    elsif param.nil?
      to_a.my_each { |n| return true if n }
    elsif !param.nil? && (param.is_a? Class)
      to_a.my_each { |n| return true if [n.class, n.class.superclass, n.class.superclass].include?(param) }
    elsif !param.nil? && (param.is_a? Regexp)
      to_a.my_each { |n| return true if n.match(param) }
    else
      to_a.my_each { |n| return true if n == param }
    end
    false
  end

  def my_none?(param = nil)
    if block_given?
      my_each { |n| return false if yield(n) }
    elsif param.nil?
      to_a.my_each { |n| return false if n }
    elsif !param.nil? && (param.is_a? Class)
      my_each { |n| return false if [n.class, n.class.superclass, n.class.superclass].include?(param) }
    elsif !param.nil? && (param.is_a? Regexp)
      my_each { |n| return false if n.match(param) }
    else
      my_each { |n| return false if n == param }
    end
    true
  end

  def my_count(param = nil)
    counter = 0
    if block_given?
      my_each { |n| counter += 1 if yield(n) }
    elsif param.nil?
      my_each { |_n| counter += 1 }
    else
      my_each { |n| counter += 1 if n == param }
    end
    counter
  end

  def my_map(proc = nil)
    return enum_for(:my_map, proc) unless !proc.nil? || block_given?
 
    arr = []
    if proc.nil?
      to_a.my_each { |item| arr << yield(item) }
    else
      to_a.my_each { |item| arr << proc.call(item) }
    end
    arr
  end

  #p [1,2,4,2,1].my_map(Proc.new {|number| number*2})


  def my_inject(result = nil, symbol = nil)
    if (result.is_a?(Symbol) || result.is_a?(String)) && (!result.nil? && symbol.nil?)
      symbol = result
      result = nil
    end
    if !block_given? && !symbol.nil?
      to_a.my_each { |n| result = result.nil? ? n : result.send(symbol, n) }
    else
      to_a.my_each { |n| result = result.nil? ? n : yield(result, n) }
    end
    result
  end
end

def multiply_els(arr)
  arr.my_inject(:*)
end

# testing

# my_each
 p [1,2,4,5,6].my_each {|i| puts i+1}
# [1,2,4,5,6].my_each {|items| p items**2 }

# my_each_with_index
# %w[Tiago emmy 123 arthur cake].my_each_with_index {|x| puts "hello #{x}"}

# my_select
# [4,2,7,2,9,10,5].my_select { |v| puts "number greater than 5 #{v}"}

# my_any?
# [4,2,7,2,9,10,5].my_any? {|p| puts "Here there are numbers #{p}"}

# my_all?
# [3,3,3].my_all? {|p| puts "The cond is #{p}"}
# [7,2,2,7].my_all? {|p| puts "The cond is #{p}"}

# my_none?
# [3,3,3].my_none? {|p| puts "The condition is #{p}"}
# [7,2,2,7].my_none? {|p| puts "The condition is #{p}"}

# my_map
#[1,2,3,5,6,7].my_map { |name| puts "#{name*2}".concat(" Tiago")}

# my_inject?
# [1,2,3,5,6,7].my_inject {|sum| puts sum}
