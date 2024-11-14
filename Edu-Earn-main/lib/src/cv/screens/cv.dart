import 'package:edu_earn/src/cv/widgets/cv_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_resume_template/flutter_resume_template.dart';
import 'package:get/get.dart';

import '../../../shared/data/image_assets.dart';
import '../data/data.dart';

class CVPage extends StatefulWidget {
  const CVPage({super.key});

  @override
  State<CVPage> createState() => _CVPageState();
}

class _CVPageState extends State<CVPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CV Generator",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFFFFE28D),
              foregroundImage: AssetImage(ImageAssets.profile),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                height: 180,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Elevate Your Carrer\n Journey",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text("Craft your perfect CV with\n our intuitive app",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300)),
                      ],
                    ),
                    SizedBox(width: 130, child: Image.asset(ImageAssets.cv, fit: BoxFit.cover)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 170,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade800
                            : Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ImageAssets.cvs),
                          const SizedBox(width: 8),
                          Text(
                            "Create CV",
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Get.to(() => const CVTemplate());
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 170,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade800
                            : Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ImageAssets.cvTemplate),
                          const SizedBox(width: 8),
                          Text(
                            "Template",
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => CVTemplate(type: TemplateTheme.modern));
                          },
                          splashColor: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            height: 200,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade800
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            child: FlutterResumeTemplate(
                              data: data,
                              templateTheme: TemplateTheme.modern,
                              mode: TemplateMode.readOnlyMode,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => CVTemplate(type: TemplateTheme.none));
                          },
                          splashColor: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            height: 200,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade800
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            child: FlutterResumeTemplate(
                              data: data,
                              templateTheme: TemplateTheme.none,
                              mode: TemplateMode.readOnlyMode,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => CVTemplate(type: TemplateTheme.business));
                          },
                          splashColor: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            height: 200,
                            width: 150,
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade800
                                  : Theme.of(context).colorScheme.primary,
                            )),
                            child: FlutterResumeTemplate(
                              data: data,
                              templateTheme: TemplateTheme.business,
                              mode: TemplateMode.readOnlyMode,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => CVTemplate(type: TemplateTheme.technical));
                          },
                          splashColor: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            height: 200,
                            width: 150,
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade800
                                  : Theme.of(context).colorScheme.primary,
                            )),
                            child: FlutterResumeTemplate(
                              data: data,
                              templateTheme: TemplateTheme.technical,
                              mode: TemplateMode.readOnlyMode,
                            ),
                          ),
                        ),
                      ],
                    ),
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
