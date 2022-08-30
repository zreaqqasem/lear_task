import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utils/Colors.dart';

class RoundedButton extends StatefulWidget {
  final String? text;
  final VoidCallback press;
  final Color color, textColor;
  final double? width;
  final double? cornerRadius;
  final double? height;
  final bool? isLoading;
  final bool? enabled;

  const RoundedButton({
    Key? key,
    required this.text,
    required this.isLoading,
    required this.enabled,
    required this.press,
    required this.color,
    required this.textColor,
    required this.width,
    required this.cornerRadius,
    required this.height,
  }) : super(key: key);

  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.enabled!) {
      return SizedBox(
            width: widget.width ?? 0.8 * size.width,
            height: widget.height ?? 0.15 * size.width,
            child: MaterialButton(
              color: widget.color,
              onPressed: widget.press,
              child: Text(
                widget.text ?? "ss ",
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 12,
                ),
              ),
            ),
          );
    } else {
      return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: widget.width ?? 0.8 * size.width,
            height: widget.height ?? 0.15 * size.width,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(
                  widget.cornerRadius != null ? 0 : 0),
            ),
            child: Center(
                child: Stack(
              children: [
                Center(
                  child: Text(
                    widget.text ?? "Continue",
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 12,
                    ),
                  ),
                ),
                Visibility(
                    visible: widget.isLoading!,
                    child: SizedBox(
                      width: widget.width ?? 0.8 * size.width,
                      height: widget.height ?? size.height*0.06,
                      child: const Center(
                          child: CupertinoActivityIndicator(
                        color: PrimaryAppColor,
                      )),
                    ))
              ],
            )),
          );
    }
  }
}
