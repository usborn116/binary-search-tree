require_relative './classes.rb'

array = Array.new(15) { rand(1..100) }
bst = Tree.new(array)

bst.pretty_print

p "Balanced? #{bst.balanced?}"

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

puts 'Inorder traversal: '
puts bst.inorder
p bst.pretty_print
p bst.balanced?

p "Rebalancing"
bst.rebalance

p bst.balanced?
p bst.pretty_print
puts 'Level order traversal: '
puts bst.level_order

puts 'Preorder traversal: '
puts bst.preorder

puts 'Inorder traversal: '
puts bst.inorder

puts 'Postorder traversal: '
puts bst.postorder