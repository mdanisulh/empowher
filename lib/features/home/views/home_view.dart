import 'package:empowher/common/loading_page.dart';
import 'package:empowher/features/auth/controller/auth_controller.dart';
import 'package:empowher/features/community/views/community_view.dart';
import 'package:empowher/features/home/views/chat_view.dart';
import 'package:empowher/features/user_profile/views/edit_profile_view.dart';
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
    ChatView(),
    CommunityView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(currentUserDetailsProvider).value;
    if (user == null) return const Loader();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Image.asset(
          'assets/images/EmpowHer.png',
          height: 50,
          color: Colors.deepPurple,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SizedBox.shrink(),
                label: 'Schemes',
              ),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(),
                label: 'Saheli',
              ),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(),
                label: 'Community',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.deepPurple,
            onTap: _onItemTapped,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundImage: Image.network(user.photoURL, fit: BoxFit.contain).image,
              ),
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem<String>(
                  child: const Text('Edit Profile'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileView(willPop: true)));
                  },
                ),
                PopupMenuItem<String>(
                  child: const Text('Sign Out'),
                  onTap: () => ref.read(authControllerProvider.notifier).logout(context: context),
                ),
              ];
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
