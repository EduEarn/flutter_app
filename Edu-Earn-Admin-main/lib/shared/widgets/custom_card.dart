import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.color,
    required this.bgColor,
    required this.number,
     this.icon,
    required this.title,
  });

  final Color color;
  final Color bgColor;
  final String number;
  final IconData? icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xffEFF3F5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.grey,
                    size: 17,
                  ),
                ),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const Spacer(),
              const Padding(
                padding:  EdgeInsets.only(right: 8.0),
                child:  Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                  size: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Text(
                  number,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700, fontSize: 25),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 80,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "15.8%",
                    style: TextStyle(color: color),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
