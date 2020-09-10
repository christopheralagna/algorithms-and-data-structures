require 'pry'

class Node
  include Comparable
  attr_accessor :data, :left, :right

=begin
  def <=>(other)
    data <=> other.data
  end
=end

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

end

class Tree
  attr_accessor :array, :root, :number_of_nodes

  def initialize(array)
    @array = array.sort
    @number_of_nodes = 0
    @root = build_tree(array)
  end

  def build_tree(array)
    return nil if array.empty?
    mid = (array.length - 1)/2
    node = Node.new(array[mid])
    @number_of_nodes += 1

    node.left = build_tree(array.slice(0, mid))
    node.right = build_tree(array.slice(mid+1, array.length - 1))

    return node
  end

  def insert(value, target_node = @root)
    new_node = Node.new(value)
    return new_node if target_node.nil?

    case new_node.data <=> target_node.data
    when -1
      target_node.left = insert(data, target_node.left)
    when 1
      target_node.right = insert(data, target_node.right)
    when 0
      return new_node
    end
    target_node
  end

  def delete(value, target_node = @root)
    node_to_delete = Node.new(value)
    return target_node if target_node.nil?

    case node_to_delete.data <=> target_node.data
    when -1
      target_node.left = delete(value, target_node.left)
    when 1
      target_node.right = delete(value, target_node.right)
    when 0
      if target_node.left == nil
        temp = target_node.right
        target_node = nil
        return temp
      elsif target_node.right == nil
        temp = target_node.left
        target_node = nil
        return temp
      else
        temp = self.inorder(target_node.right)[0]
        target_node.data = temp
        target_node.right = delete(temp, target_node.right)
      end
    end
    target_node
  end

  def find(value)
    nodes = level_order()
    nodes.each { |node| return node if node.data = value}
  end

  def level_order()
    array = []
    queue = Queue.new()
    queue.push(root)
    while !queue.empty?
      node = queue.pop()
      array << node
      queue.push(node.left) if node.left != nil
      queue.push(node.right) if node.right != nil
    end
    return array
  end

  def preorder(root = @root, array = [])
    return if root == nil
    array << root.data
    preorder(root.left, array)
    preorder(root.right, array)
    return array
  end

  def inorder(root = @root, array = [])
    return if root == nil
    inorder(root.left, array)
    array << root.data
    inorder(root.right, array)
    return array
  end

  def postorder(root = @root, array = [])
    return if root == nil
    postorder(root.left, array)
    postorder(root.right, array)
    array << root.data
    return array
  end

  def height()

  end

  def depth(node, root = @root)
    depth = 0
    until root == nil
      case node.data <=> root.data
      when -1
        root = root.left
        depth += 1
      when 0
        return depth
      when 1
        root = root.right
        depth += 1
      end
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

end

array = [1,2,3,4,6,8,9]

new_tree = Tree.new(array)
new_tree.pretty_print
new_tree.delete(4)
new_tree.pretty_print
