import 'package:animations/animations.dart';
import 'package:coin_crawler_app/widgets/coins_screen/coins_screen_widget.dart';
import 'package:coin_crawler_app/widgets/home_screen/home_screen_widget.dart';
import 'package:coin_crawler_app/widgets/wallet_screen/wallet_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainLayoutWidget extends StatefulWidget {
  const MainLayoutWidget({Key? key, required this.restorationId})
      : super(key: key);
  final String restorationId;
  // final MainLayoutWidgetType type;

  @override
  State<MainLayoutWidget> createState() => _MainLayoutWidgetState();
}

class _MainLayoutWidgetState extends State<MainLayoutWidget>
    with RestorationMixin {
  final RestorableInt _currentIndex = RestorableInt(0);

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_currentIndex, 'bottom_navigation_tab_index');
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    var bottomNavigationBarItems = const [
      BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
      BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on), label: 'Coins'),
      BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
    ];

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).colorScheme.background,
      statusBarIconBrightness:
          Theme.of(context).colorScheme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
      systemNavigationBarColor:
          Theme.of(context).colorScheme.inversePrimary.withOpacity(.8),
    ));
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
            return FadeThroughTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              fillColor: colorScheme.background,
              child: child,
            );
          },
          child: _NavigationDestinationWidget(
            key: UniqueKey(),
            item: bottomNavigationBarItems[_currentIndex.value],
            index: _currentIndex.value,
            // selectedTabWidget: tabsWidgets[_currentIndex.value],
          ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomNavigationBar(
            items: bottomNavigationBarItems,
            currentIndex: _currentIndex.value,
            onTap: (index) {
              setState(() {
                _currentIndex.value = index;
              });
            },
            selectedItemColor: colorScheme.brightness == Brightness.light
                ? colorScheme.onBackground
                : colorScheme.onBackground,
            unselectedItemColor: colorScheme.onBackground.withOpacity(.7),
            backgroundColor: colorScheme.inversePrimary,
          ),
        ),
      ),
    );
  }
}

class _NavigationDestinationWidget extends StatelessWidget {
  const _NavigationDestinationWidget(
      {Key? key, required this.item, required this.index})
      : super(key: key);

  final BottomNavigationBarItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    var tabsWidgets = <Widget>[
      const HomeScreenWidget(),
      const CoinsScreenWidget(),
      const WalletScreenWidget(),
    ];

    return tabsWidgets[index];
  }
}
