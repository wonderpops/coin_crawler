import 'package:animations/animations.dart';
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

    var bottomNavigationBarItems = const <BottomNavigationBarItem>[
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
                ? colorScheme.background
                : colorScheme.onBackground,
            unselectedItemColor: colorScheme.primary.withOpacity(.6),
            backgroundColor: colorScheme.inversePrimary,
          ),
        ),
      ),
    );
  }
}

class _NavigationDestinationWidget extends StatelessWidget {
  const _NavigationDestinationWidget({Key? key, required this.item})
      : super(key: key);

  final BottomNavigationBarItem item;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 100,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              height: 60,
            ),
          );
        });
  }
}
