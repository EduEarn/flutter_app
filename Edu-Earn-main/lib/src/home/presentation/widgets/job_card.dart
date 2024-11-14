import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  const JobCard({
    super.key,
    required this.role,
    required this.company,
    required this.amount,
    required this.image,
    this.onTap,
  });

  final String role;
  final String company;
  final String amount;
  final String image;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: Container(
          width: 200,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: image,
                placeholder: (context, url) => const SizedBox(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(role, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text("$company   $amount"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
