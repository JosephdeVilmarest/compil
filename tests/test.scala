class BST(l: BST, v: Int, r: BST) {

  var left = l;
  var value = v;
  var right = r;

  def add(x: Int) {
    if (x == value) return;
    if (x < value) {
      if (left eq null)
	left = new BST(null, x, null)
      else
	left.add(x)
    } else
      if (right eq null)
	right = new BST(null, x, null)
      else
	right.add(x)
  };

  def contains(x: Int) : Boolean = {
    if (x == value) return true;
    if (x < value && (left ne null)) return left.contains(x);
    if (right ne null) return right.contains(x);
    return false
  };

  def display() {
    if (left ne null) left.display();
    print(" "); print(value); print(" ");
    if (right ne null) right.display()
  }

}

object Main {
  def main(args: Array[String]) {
    
      print("ok\n")
  }

}
