require 'pry'

class LinkedLists
  attr_reader :head, :tail, :size

  def initialize()
    @head = nil
    @tail = nil
    @size = 0
  end

  def append(value)
    appended_node = Node.new()
    appended_node.value = value
    if @tail != nil
      @tail.pointer = appended_node
    elsif @size == 0
      @head = appended_node
    end
    @tail = appended_node
    @size += 1
  end

  def prepend(value)
    prepended_node = Node.new()
    prepended_node.value = value
    if @head != nil
      prepended_node.pointer = @head
    elsif size == 0
      @tail = prepended_node
    end
    @head = prepended_node
    @size += 1
  end

  def at(index)
    node = @head
    index.times do
      node = node.next_node()
    end
    return node.value
  end

  def pop()
    node = @head
    until node.next_node == @tail
      node = node.next_node
    end
    @size -= 1
    node.pointer = nil
    @tail = node
  end

  def contains?(value)
    node = @head
    self.size.times do
      return true if node.value == value
      node = node.next_node
    end
    return false
  end

  def find(value)
    node = @head
    for i in 0..self.size-1 do
      return i if node.value == value
      node = node.next_node
    end
    return nil
  end

  def to_s()
    node = @head
    self.size.times do
      print "( #{node.value} ) -> "
      node = node.next_node
    end
    print "nil\t"
  end

end

class Node
  attr_accessor :value, :pointer

  def initialize()
    @value = nil
    @pointer = nil
  end

  def next_node()
    return @pointer
  end

end

linked_list = LinkedLists.new()

linked_list.append('first')
linked_list.append('second')
linked_list.append('third')

linked_list.to_s()
