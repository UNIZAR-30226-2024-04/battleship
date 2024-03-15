import 'package:flutter/material.dart';


class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CustomCheckbox({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value; // Establece el valor inicial del checkbox
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
          widget.onChanged?.call(_value);
        });
      },
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Colors.white, // Color del borde
            width: 2.0,
          ),
          color: Colors.white,
        ),
        child: _value
            ? Icon(
                Icons.check,
                size: 18.0,
                color: Colors.black, // Color de la cruz cuando se marca
              )
            : null,
      ),
    );
  }
}