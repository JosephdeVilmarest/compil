
class Job[-A] { def work(x: A) {} }

class Knot extends Job[Int] {
  var j = new Job[Int]();
  var acc = 1;
  override def work(x: Int) {
    if(x == 0)
      print(x)
    else {
      work(x-1)
    }
  }
}

object Main { def main(a: Array[String]) { var k = new Knot(); a.work(0) } }

