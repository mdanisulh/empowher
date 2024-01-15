import 'package:empowher/features/auth/controller/auth_controller.dart';
import 'package:empowher/features/home/views/scheme_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    SchemeView(),
    Text('Tab 2'),
    Text('Tab 3'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EmpowHer'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SizedBox.shrink(),
                label: 'Tab 1',
              ),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(),
                label: 'Tab 2',
              ),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(),
                label: 'Tab 3',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout(context: context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
