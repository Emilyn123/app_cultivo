import 'package:flutter/material.dart';

class CampoTexto extends StatefulWidget {
  final IconData icono;
  final String textoHint;
  final bool esPassword;
  final String? Function(String?)? validador;

  const CampoTexto({
    super.key,
    required this.icono,
    required this.textoHint,
    this.esPassword = false,
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
        obscureText: _ocultarTexto,
        validator: widget.validador,
        decoration: InputDecoration(
          hintText: widget.textoHint,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          prefixIcon: Icon(widget.icono, color: const Color(0xFF2E7D32)),
          suffixIcon: widget.esPassword
              ? IconButton(
                  icon: Icon(
                    _ocultarTexto ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF2E7D32),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
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
