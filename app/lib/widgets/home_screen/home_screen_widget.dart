import 'package:flutter/material.dart';

class HomeScreenWidget extends StatelessWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 16),
        _TopScreenGreetingWidget(),
        SizedBox(height: 32),
        _WalletPreviewWidget()
      ],
    );
  }
}

class _TopScreenGreetingWidget extends StatelessWidget {
  const _TopScreenGreetingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Good Evening,',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                'Wonderpop',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      child: Icon(Icons.notifications_none,
                          color: colorScheme.inverseSurface),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // showModalBottomSheet(
                        //     backgroundColor: Colors.transparent,
                        //     context: context,
                        //     builder: (context) {
                        //       //   return _NotificationsBoxWidget(
                        //       //       notifications: notifications);
                        //     });
                      },
                      splashColor: colorScheme.tertiary.withOpacity(.3),
                      hoverColor: colorScheme.tertiary.withOpacity(.3),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        alignment: Alignment.center,
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Positioned(
                        top: 8,
                        right: 10,
                        child: Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                              color: colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(8)),
                        )),
                  )
                ],
              ),
              const SizedBox(width: 16),
              CircleAvatar(
                radius: 30,
                backgroundColor: colorScheme.inversePrimary,
                child: const Icon(Icons.person_outline_outlined,
                    color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _WalletPreviewWidget extends StatelessWidget {
  const _WalletPreviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.primaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Wallet',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: colorScheme.secondary.withOpacity(.4)),
                      child: const Icon(
                        Icons.arrow_drop_down,
                        // color: colorScheme.primary,
                        size: 24,
                      ))
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Total balance',
                style:
                    TextStyle(fontSize: 18, color: colorScheme.inverseSurface),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '\$',
                    style: TextStyle(fontSize: 14),
                  ),
                  const Text(
                    '0.12412',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '(+ 0.012)',
                    style: '(+ 0.012)'.contains('+')
                        ? const TextStyle(fontSize: 14, color: Colors.green)
                        : const TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
