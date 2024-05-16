import 'package:flutter/material.dart';


/*
 * Clase que contiene los botones personalizados.
 */
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

/*
 * Clase que contiene el estado de los botones personalizados.
 */
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

/*
 * Clase que contiene los botones circulares.
 */
Widget buildCircledButton(String imagePath, String text, bool showTick, VoidCallback onPressed) {
  return Column(
    children: [
      ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(), // Forma totalmente redonda
          padding: const EdgeInsets.all(20), // Tamaño del botón
          backgroundColor: Colors.black.withOpacity(0.5), // Fondo oscuro y transparente
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              imagePath, // Ruta de la imagen
              width: 50, // Ancho de la imagen
              height: 50, // Alto de la imagen
            ),
            if (showTick)
              Image.asset(
                'images/tick.png', // Ruta de la imagen "tick.png"
                width: 50, // Ancho de la imagen
                height: 50, // Alto de la imagen
              ),
          ],
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

/*
 * Clase que contiene los botones naranjas.
 */
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
                minimumSize: const Size(250, 55),
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

/*
 * Clase que contiene los botones de texto.
 */
Widget buildTextButton (BuildContext context, VoidCallback onTapAction, String text) {
  return GestureDetector(
    onTap: onTapAction,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    ),
  );
}

/*
 * Clase que contiene las entradas de texto blancas con pista e icono.
 */
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

/*
 * Clase que contiene las entradas de texto blancas con pista, icono y escrito con asteriscos.
 */
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

/*
 * Clase que contiene las entradas de texto blancas con texto permanente y desplegable.
 */
Widget buildDropdownButton(BuildContext context, String text, List<String> items, TextEditingController controller, {String? defaultValue}) {
  String? selectedItem;

  // Comprueba si defaultValue está en items
  if (defaultValue != null && items.contains(defaultValue)) {
    selectedItem = defaultValue;
  }

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


/*
 * Clase que contiene los botones de cambio de estado.
 */
Widget buildToggleButton({required bool isActive, required VoidCallback onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 70.0,
      height: 30.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Row(
        mainAxisAlignment:
            isActive ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40.0,
            height: 40.0,
            margin: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    ),
  );
}

/*
 * Clase que contiene las entradas de texto con botón de cambio de estado.
 */
Widget buildEntryToggleButton(String text, bool isActive, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Container(
          width: 300, 
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0),
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        Positioned(
          right: 10, 
          child: Container(
            child: buildToggleButton(isActive: isActive, onPressed: onPressed),
          ),
        ),
      ],
    ),
  );
}