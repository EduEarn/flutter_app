import 'package:flutter/material.dart';
import 'package:flutter_resume_template/flutter_resume_template.dart';
import '../../../shared/data/image_assets.dart';
import '../data/data.dart';

class CVTemplate extends StatefulWidget {
  const CVTemplate({super.key, required this.type});

  final TemplateTheme type;

  @override
  State<CVTemplate> createState() => _CVTemplateState();
}

class _CVTemplateState extends State<CVTemplate> {
  final GlobalKey<_CVTemplateState> globalKey = GlobalKey<_CVTemplateState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        title: Text("Template", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17)),
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
        child: Column(
          children: [
            FlutterResumeTemplate(
              data: data,
              templateTheme: widget.type,
              mode: TemplateMode.onlyEditableMode,
              onSaveResume: (globalKey) async {
                return await PdfHandler().createResume(globalKey);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          Navigator.pop(context);
          // await PdfHandler().createPDF(globalKey);
          // print(await PdfHandler().prepareSaveDir());
        },
        child: const Icon(
          Icons.download,
          color: Colors.white,
        ),
      ),
    );
  }
}
