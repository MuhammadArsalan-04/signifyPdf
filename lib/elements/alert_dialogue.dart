import 'package:flutter/material.dart';

Future showErrorDialogue(BuildContext context,
    {String? title,
    required String message,
    Function? onPressedYes,
    Function? onPressedNo}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: title == null
          ? const Text(
              "Alert!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            )
          : Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.green),
            ),
      content: Text(message,
          style: const TextStyle(
            color: Colors.black,
          )),
      actions: [
        TextButton(
            onPressed: () => onPressedNo!(),
            child: const Text(
              "No",
              style: TextStyle(
                color: Colors.blue,
              ),
            )),
        TextButton(
            onPressed: () => onPressedYes!(),
            child: const Text(
              "Yes",
              style: TextStyle(
                color: Colors.blue,
              ),
            ))
      ],
    ),
  );
}
