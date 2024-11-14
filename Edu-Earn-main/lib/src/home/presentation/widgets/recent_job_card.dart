import 'package:cached_network_image/cached_network_image.dart';
import 'package:edu_earn/shared/data/image_assets.dart';
import 'package:flutter/material.dart';

class RecentJobCard extends StatelessWidget {
  const RecentJobCard({
    super.key,
    required this.role,
    required this.type,
    required this.companyName,
    required this.location,
    required this.description,
    required this.date,
    required this.amount,
    required this.level,
    required this.image,
    this.onTap,
  });

  final String role;
  final String type;
  final String description;
  final String companyName;
  final String location;
  final String date;
  final String amount;
  final String level;
  final String image;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          height: 230,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : const Color(0xFF5424FD),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) => const SizedBox(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        companyName,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 95,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "View",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
                          ),
                          Image.asset(ImageAssets.send)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:
                          Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : const Color(0xFF612EFC),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[900]!
                            : const Color(0xFF835EFD),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          location,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:
                          Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : const Color(0xFF612EFC),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[900]!
                            : const Color(0xFF835EFD),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          level,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[900]
                            : const Color(0xFF612EFC),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[900]!
                              : const Color(0xFF835EFD),
                          width: 2,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_clock, color: Colors.white, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          type,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(date),
              ],
            ),
            Text(amount),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
