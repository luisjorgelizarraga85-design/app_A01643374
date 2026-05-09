import 'dart:io';
import 'package:flutter/material.dart';

/// Widget que muestra la imagen seleccionada o un placeholder si no hay imagen
class ImagePreview extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;

  const ImagePreview({super.key, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: image == null ? onTap : null,
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF0077B6).withOpacity(0.5),
            width: 1.5,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: image != null
            // ── Imagen cargada ─────────────────────────────────────────────
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(image!, fit: BoxFit.cover),
                  // Overlay sutil en la parte inferior
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent
                          ],
                        ),
                      ),
                      child: const Text(
                        'Imagen lista para analizar',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              )
            // ── Placeholder sin imagen ─────────────────────────────────────
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.biotech,
                    size: 64,
                    color: const Color(0xFF0077B6).withOpacity(0.6),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Carga una imagen de microscopio',
                    style: TextStyle(
                        color: Colors.white60,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Toca aquí o usa el botón de abajo',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
      ),
    );
  }
}
