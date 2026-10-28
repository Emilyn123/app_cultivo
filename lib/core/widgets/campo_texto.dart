import 'package:flutter/material.dart';

class CampoTexto extends StatefulWidget {
  final IconData icono;
  final String textoHint;
  final bool esPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validador;

  const CampoTexto({
    super.key,
    required this.icono,
    required this.textoHint,
    this.esPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.validador,
  });

  @override
  State<CampoTexto> createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  late bool _ocultarTexto;

  @override
  void initState() {
    super.initState();
    _ocultarTexto = widget.esPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black26),
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _ocultarTexto,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        validator: widget.validador,
        decoration: InputDecoration(
          hintText: widget.textoHint,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
          prefixIcon: Icon(widget.icono, color: const Color(0xFF2E7D32)),
          suffixIcon: widget.esPassword
              ? IconButton(
                  icon: Icon(
                    _ocultarTexto ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF2E7D32),
                  ),
                  onPressed: () {
                    setState(() {
                      _ocultarTexto = !_ocultarTexto;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
        ),
      ),
    );
  }
}
