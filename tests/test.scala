class A {
def f() : Int = { return 0 };
def g() : Boolean = { return true }
}
class B extends A {
override def f() : Int = { return 1 };
def h() : Boolean = { return false }
}

object Main {
    def main(args: Array[String]) {
        if (1<2) print("je suis content\n") else print("je ne suis pas content\n")
    }
}
