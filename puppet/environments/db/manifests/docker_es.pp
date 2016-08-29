class dockerESNode {
  docker::image { 'elasticsearch': image_tag => 2.3 }

  docker::run { 'elasticsearch-node1':
  }
}
