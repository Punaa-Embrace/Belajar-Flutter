class CounterController {
  int count = 0;
  List<int> history = [];

  void increment() {
    count++;
    history.add(count);
  }

  void decrement() {
    count--;
    history.add(count);
  }
}