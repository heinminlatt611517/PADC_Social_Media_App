import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/text_detection_bloc.dart';
import 'package:social_media_app/utils/extensions.dart';
import 'package:social_media_app/widgets/primary_button_view.dart';

class TextDetectionPage extends StatelessWidget {
  const TextDetectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TextDetectionBloc(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Row(
              children: [Icon(Icons.chevron_left), Text("Back")],
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<TextDetectionBloc>(
                    builder: (context, bloc, child) => Visibility(
                        visible: bloc.chooseImageFile != null,
                        child: Image.file(
                          bloc.chooseImageFile ?? File(""),
                          width: 300,
                          height: 300,
                        ))),
                const SizedBox(
                  height: 24,
                ),
                Consumer<TextDetectionBloc>(
                  builder: (context, bloc, child) {
                    return GestureDetector(
                      child: const PrimaryButtonView(
                        label: "Choose Image",
                      ),
                      onTap: () {
                        ImagePicker()
                            .pickImage(source: ImageSource.gallery)
                            .then((pickedImageFile) async {
                          var bytes = await pickedImageFile?.readAsBytes();
                          bloc.onImageChosen(File(pickedImageFile?.path ?? ""),
                              bytes ?? Uint8List(0));
                        }).catchError((error) {
                          showSnackBarWithMessage(
                              context, "Image cannot be picked");
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
