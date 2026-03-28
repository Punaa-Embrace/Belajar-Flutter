import 'package:flutter/material.dart';
import '../controller/counter_controller.dart';
import 'history_page.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final controller = CounterController();
  bool isDark = false;

  void update() {
    setState(() {});
  }
  

  String getMessage() {
    if (controller.count == 0) {
      return "Kasi Mulai ngitung";
    } else if (controller.count < 0) {
      return "Kocak kok bisa mines";
    } else if (controller.count < 5) {
      return "Masih dikit";
    } else if (controller.count < 10) {
      return "Whooop Bisa itu";
    } else {
      return "Omakkk Dah gacor yaa";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                isDark = !isDark;
              });
            },
          )
        ],
      ),
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.all(30),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    colors: [Colors.deepPurple, Colors.black],
                  )
                : const LinearGradient(
                    colors: [Colors.white, Color(0xFFEDE7F6)],
                  ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 15,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              /// TITLE
              const Text(
                "✨ Counter App",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              

              /// ANIMATED COUNTER
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Text(
                  "${controller.count}",
                  key: ValueKey(controller.count),
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.deepPurple,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// MESSAGE
              Text(
                getMessage(),
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey[300] : Colors.grey,
                ),
              ),

              const SizedBox(height: 25),

              /// BUTTONS WITH ANIMATION
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _animatedButton(Icons.remove, () {
                    controller.decrement();
                    update();
                  }),
                  const SizedBox(width: 20),
                  _animatedButton(Icons.add, () {
                    controller.increment();
                    update();
                  }),
                ],
                
              )
            ],
          ),
        ),
      ),
    );
  }
  

  Widget _animatedButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
