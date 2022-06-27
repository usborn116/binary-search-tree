class Node
  attr_accessor :left, :right, :data

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
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
    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    else
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  def delete(value, node = root)
    return node if node.nil?
    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?
      # if node has two children
      leftmost_node = leftmost_leaf(node.right)
      p node.data = leftmost_node.data
      p node.right = delete(leftmost_node.data, node.right)
    end
    node
  end

  def leftmost_leaf(node)
    node = node.left until node.left.nil?
    p node
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
    result
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
    unless node.nil? || node == root
      node = (node.instance_of?(Node) ? find(node.data) : find(node))
    end
    return -1 if node.nil?
    [height(node.left), height(node.right)].max + 1
  end

  def depth(node = root, parent = root, edges = 0)
    return 0 if node == parent
    return -1 if parent.nil?
    if node < parent.data
      edges += 1
      depth(node, parent.left, edges)
    elsif node > parent.data
      edges += 1
      depth(node, parent.right, edges)
    else
      edges
    end
  end

  def balanced?(node = root)
    return true if node.nil?
    left_height = height(node.left)
    right_height = height(node.right)
    return true if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)
    false
  end

  def rebalance
    self.data = inorder_array
    self.root = build_tree(data)
  end

  def pretty_print(node = root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def inorder_array(node = root, array = [])
    unless node.nil?
      inorder_array(node.left, array)
      array << node.data
      inorder_array(node.right, array)
    end
    array
  end
end


array = Array.new(15) { rand(1..100) }
bst = Tree.new(array)

bst.pretty_print

p bst.balanced?

puts 'Level order traversal: '
puts bst.level_order

puts 'Preorder traversal: '
puts bst.preorder

puts 'Inorder traversal: '
puts bst.inorder

puts 'Postorder traversal: '
puts bst.postorder

10.times do
  a = rand(100..200)
  bst.insert(a)
  puts "Inserted #{a}."
end

p bst.balanced?

p "Rebalancing"
bst.rebalance

p bst.balanced?

puts 'Level order traversal: '
puts bst.level_order

puts 'Preorder traversal: '
puts bst.preorder

puts 'Inorder traversal: '
puts bst.inorder

puts 'Postorder traversal: '
puts bst.postorder