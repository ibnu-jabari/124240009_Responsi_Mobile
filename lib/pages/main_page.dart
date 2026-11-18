import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/cart_button.dart';
import 'home_page.dart';
import 'profile_page.dart';

/// Kerangka utama: BottomNavigationBar dengan 2 tab (Home dan Profile).
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  AppBar _buildAppBar() {
    if (_index == 0) {
      // Tab Home: nama aplikasi + ikon keranjang di AppBar.
      return AppBar(
        title: const Text(
          'Shopedia',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        actions: const [CartButton(), SizedBox(width: 4)],
      );
    }
    return AppBar(title: const Text('Profil'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      // IndexedStack menjaga state tiap tab (daftar produk tidak dimuat ulang).
      body: IndexedStack(
        index: _index,
        children: const [HomePage(), ProfilePage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
