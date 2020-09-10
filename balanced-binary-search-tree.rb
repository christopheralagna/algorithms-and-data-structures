require 'pry'

class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :array, :number_of_nodes, :root

  def initialize(array)
    @array = array.uniq.sort
    @number_of_nodes = 0
    @root = build_tree(@array)
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

  def insert(value, root = @root)
    new_node = Node.new(value)
    return new_node if root.nil?

    case new_node.data <=> root.data
    when -1
      root.left = insert(value, root.left)
    when 1
      root.right = insert(value, root.right)
    when 0
      return new_node
    end
    root
  end

  def delete(value, root = @root)
    return root if root.nil?

    case value <=> root.data
    when -1
      root.left = delete(value, root.left)
    when 1
      root.right = delete(value, root.right)
    when 0
      if root.left == nil
        temp = root.right
        root = nil
        return temp
      elsif root.right == nil
        temp = root.left
        root = nil
        return temp
      else
        temp = self.inorder(root.right)[0]
        root.data = temp
        root.right = delete(temp, root.right)
      end
    end
    root
  end

  def find(value)
    nodes = level_order()
    nodes.each { |node| return node if node.data == value }
  end

  def level_order()
    array = []
    queue = Queue.new()
    queue.push(@root)
    while !queue.empty?
      node = queue.pop()
      array << node.data
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

  def height(target_node)
    return -1 if target_node.nil?

    left_height = height(target_node.left)
    right_height = height(target_node.right)

    left_height > right_height ? left_height + 1 : right_height + 1
  end

  def depth(target_node, root = @root)
    return nil if root.nil?

    case target_node.data <=> root.data
    when -1
      depth = depth(target_node, root.left)
      return depth + 1
    when 1
      depth = depth(target_node, root.right)
      return depth + 1
    when 0
      return 0
    end
  end

  def balanced?(root = @root)
    return -1 if root.nil?

    left_height = height(root.left)
    right_height = height(root.right)
    return false if (left_height - right_height).abs() > 1
    
    unless left_height == false || right_height == false
      left_height > right_height ? left_height + 1 : right_height + 1
    end
    return true
  end

  def rebalance()
    array = self.inorder
    @root = build_tree(array)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

new_tree = Tree.new(Array.new(15) { rand(1..100) })
new_tree.pretty_print
puts "Is the above tree balanced?: #{new_tree.balanced?()}"
p "Level order: #{new_tree.level_order()}"
p "Preorder: #{new_tree.preorder()}"
p "Postorder: #{new_tree.postorder()}"
p "Inorder: #{new_tree.inorder()}"
10.times do
  new_tree.insert(rand(100..200))
end
new_tree.pretty_print()
puts "Is the above tree balanced?: #{new_tree.balanced?()}"
new_tree.rebalance()
new_tree.pretty_print()
puts "Is the above tree balanced?: #{new_tree.balanced?()}"
p "Level order: #{new_tree.level_order()}"
p "Preorder: #{new_tree.preorder()}"
p "Postorder: #{new_tree.postorder()}"
p "Inorder: #{new_tree.inorder()}"
