import 'package:cached_network_image/cached_network_image.dart';
import 'package:edu_earn/core/job/domain/entity/job.dart';
import 'package:flutter/material.dart';

import '../../../../shared/utils/amount_formatter.dart';
import '../../../../shared/utils/date_formatter.dart';

class JobDetailCard extends StatelessWidget {
  const JobDetailCard({
    super.key,
    required this.job,
  });

  final JobEntity job;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : const Color(0xFF5424FD),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: job.image,
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
                                job.role,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                job.companyName,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
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
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[900]
                                  : const Color(0xFF612EFC),
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
                                  job.location,
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
                                const Icon(
                                  Icons.school,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  job.level,
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
                                  job.type,
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
                      const SizedBox(height: 8),
                      Text(
                        job.description,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              // const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormatter.formatDate(job.time, 'Posted'),
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color:
                                    Theme.of(context).brightness == Brightness.dark ? Colors.grey[900]! : Colors.black,
                              ),
                        ),
                      ],
                    ),
                    Text(
                      '${AmountFormatter.formatAmount(job.amount)}/mo',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900]! : Colors.black,
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
