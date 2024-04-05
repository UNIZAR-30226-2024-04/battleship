import 'package:flutter/material.dart';

// Checkbox
class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CustomCheckbox({
    super.key,
    required this.value,
    this.onChanged,
  });

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
            ? const Icon(
                Icons.check,
                size: 18.0,
                color: Colors.black, // Color de la cruz cuando se marca
              )
            : null,
      ),
    );
  }
}

// Botones circulares.
Widget buildCircledButton(String imagePath, String text) {
  return Column(
    children: [
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(), // Forma totalmente redonda
          padding: const EdgeInsets.all(20), // Tamaño del botón
          backgroundColor: Colors.black.withOpacity(0.5), // Fondo oscuro y transparente
        ),
        child: Image.asset(
          imagePath, // Ruta de la imagen
          width: 50, // Ancho de la imagen
          height: 50, // Alto de la imagen
        ),
      ),
      const SizedBox(height: 5), // Espaciado entre el botón y el texto
      Text(
        text,
        style: const TextStyle(color: Colors.white),
      ), // Texto debajo del botón
    ],
  );
}

// Botón amarillo.
Widget buildActionButton(BuildContext context, VoidCallback? onPressed, String text) {
  return Column(
    children: [
      SizedBox(
        child: Stack(
          children: [
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Colors.orange,
                minimumSize: const Size(270, 70),
                elevation: 8,
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// Texto clicable.
Widget buildTextButton (BuildContext context, VoidCallback onTapAction, String text) {
  return GestureDetector(
    onTap: onTapAction,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white, // Color del texto
        fontSize: 16.0, // Tamaño del texto
      ),
    ),
  );
}

// Entrada de texto blanca con pista e icono.
Widget buildEntryButton(String text, String hintText, IconData icono, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          filled: true,
          fillColor: Colors.white,
          labelText: text,
          hintText: hintText,
          suffixIcon: Icon(icono),
        ),
      ),
    ),
  );
}

// Entrada de texto blanca con pista, icono y escrito con asteriscos.
Widget buildEntryAstButton(String text, String hintText, IconData icono, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: SizedBox(
      width: 300,
      child: TextField(
        obscureText: true,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          filled: true,
          fillColor: Colors.white,
          labelText: text,
          hintText: hintText,
          suffixIcon: Icon(icono),
        ),
      ),
    ),
  );
}

// Entrada de texto blanca con texto permanente y desplegable.
Widget buildDropdownButton(BuildContext context, String text, List<String> items, TextEditingController controller) {
  String? selectedItem;

  return Padding(
    padding: const EdgeInsets.all(10),
    child: SizedBox(
      width: 300,
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          filled: true,
          fillColor: Colors.white,
          labelText: text,
        ),
        value: selectedItem,
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (String? newValue) {
          selectedItem = newValue;
          controller.text = newValue ?? '';
        },
      ),
    ),
  );
}
