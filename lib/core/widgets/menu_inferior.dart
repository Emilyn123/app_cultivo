import 'dart:ui';
import 'package:flutter/material.dart';

class MenuInferior extends StatelessWidget {
  final int indiceSeleccionado;
  final Function(int) alSeleccionar;

  const MenuInferior({
    super.key,
    required this.indiceSeleccionado,
    required this.alSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B3B22).withOpacity(0.85),
        border: const Border(
          top: BorderSide(color: Colors.white24, width: 0.5),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            currentIndex: indiceSeleccionado,
            onTap: alSeleccionar,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined),
                label: 'Mis Cultivos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                label: 'Alertas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
