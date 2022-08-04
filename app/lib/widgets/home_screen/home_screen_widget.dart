import 'package:flutter/material.dart';

class HomeScreenWidget extends StatelessWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TopScreenGreetingWidget(),
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
      padding: const EdgeInsets.all(16),
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
