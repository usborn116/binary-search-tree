module Printer

  def pretty_print(node = self.root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

end

class Node
  include Comparable

  attr_accessor :left, :right, :data

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
  
end

class Tree
  include Printer
  attr_accessor :root, :data

  def initialize(array)
    @data = array.sort.uniq
    @root = build_tree(data)
  end

  def build_tree(array)
    return nil if array.empty?
    middle = ((array.size) / 2).floor
    root_node = Node.new(array[middle])
    root_node.left = build_tree(array[0...middle])
    root_node.right = build_tree(array[(middle + 1)..-1])
    root_node
  end

  def insert(value, node = root)
    return nil if value == node.data
    node.left = Node.new(value) if value < node.data && node.left.nil?
    node.right = Node.new(value) if value > node.data && node.right.nil?
    insert(value, node.left ? node.left : node.right)
  end

  def delete(value, node = root)
    return node if node.nil?
    node.left = delete(value, node.left) if value < node.data
    node.right = delete(value, node.right) if value > node.data
    return node.right if node.left.nil?
    return node.left if node.right.nil?
    leftmost_node = leftmost_leaf(node.right)
    node.data = leftmost_node.data
    node.right = delete(leftmost_node.data, node.right)
    node
  end

  def leftmost_leaf(node)
    node = node.left until node.left.nil?
  end

  def find(value, node = root)
    return node if node.nil? || node.data == value
    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  def level_order(node = root, queue = [], result = [])
    queue << node
    until queue.empty?
      todo = queue.shift
      result << todo.data
      queue << todo.left unless todo.left.nil?
      queue << todo.right unless todo.right.nil?
      yield(todo) if block_given?
    end
    print result
  end

  def preorder(node = root)
    return if node.nil?
    print "#{node.data} "
    preorder(node.left)
    preorder(node.right)
  end

  def inorder(node = root)
    return if node.nil?
    inorder(node.left)
    print "#{node.data} "
    inorder(node.right)
  end

  def postorder(node = root)
    return if node.nil?
    postorder(node.left)
    postorder(node.right)
    print "#{node.data} "
  end

  def height(node = root)
    return -1 if node.nil?
    node = (node.instance_of?(Node) ? find(node.data) : find(node)) unless node == root
    return -1 if node.nil?
    [height(node.left), height(node.right)].max + 1
  end

  def depth(node = root, parent = root, edges = 0)
    return 0 if node == parent
    return -1 if parent.nil?
    node < parent.data ? depth(node, parent.left, edges += 1) : depth(node, parent.right, edges += 1)
    edges
  end

  def balanced?(node = root)
    return true if node.nil?
    left_height = height(node.left)
    right_height = height(node.right)
    return true if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)
  end

  def rebalance
    self.data = inorder_array
    self.root = build_tree(data)
  end

  def inorder_array(node = root, array = [])
    unless node.nil?
      inorder_array(node.left, array)
      array << node.data
      inorder_array(node.right, array)
    end
    array
  end

  def to_s
    pretty_print
  end

end