import 'package:flutter/material.dart';
import '../controller/counter_controller.dart';
import '../widgets/counter_button.dart';

class CounterPage extends StatefulWidget {
  final CounterController controller;
  const CounterPage({super.key, required this.controller});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  bool isDark = false;

  void update() {
    setState(() {});
  }
  

  String getMessage() {
    if (widget.controller.count == 0) {
      return "Kasi Mulai ngitung";
    } else if (widget.controller.count < 0) {
      return "Kocak kok bisa mines";
    } else if (widget.controller.count < 5) {
      return "Masih dikit";
    } else if (widget.controller.count < 10) {
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
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              /// TITLE
              const Text(
                "Counter App",
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
                  "${widget.controller.count}",
                  key: ValueKey(widget.controller.count),
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
                  CounterButton(
                    icon: Icons.remove,
                    onTap: () {
                      widget.controller.decrement();
                      update();
                    },
                  ),
                  const SizedBox(width: 20),
                  CounterButton(
                    icon: Icons.add,
                    onTap: () {
                      widget.controller.increment();
                      update();
                    },
                  ),
                ],
                
              )
            ],
          ),
        ),
      ),
    );
  }
}
