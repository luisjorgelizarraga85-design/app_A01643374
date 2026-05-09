import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../widgets/result_card.dart';
import '../widgets/image_preview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImage;       // Imagen seleccionada
  int? _cellCount;            // Resultado del conteo (se usará en Fase 2)
  bool _isAnalyzing = false;  // Estado de carga

  final ImagePicker _picker = ImagePicker();

  // ─── Seleccionar imagen desde galería ───────────────────────────────────────
  Future<void> _pickFromGallery() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _cellCount = null; // Resetear conteo al cambiar imagen
      });
    }
  }

  // ─── Tomar foto con cámara ──────────────────────────────────────────────────
  Future<void> _pickFromCamera() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 90);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _cellCount = null;
      });
    }
  }

  // ─── Placeholder: aquí irá la IA en Fase 2 ─────────────────────────────────
  Future<void> _analyzeImage() async {
  if (_selectedImage == null) return;
  setState(() => _isAnalyzing = true);

  try {
    // Convertir imagen a base64
    final bytes = await _selectedImage!.readAsBytes();
    final base64Image = base64Encode(bytes);

    // Llamar a la API de Roboflow
    final response = await http.post(
      Uri.parse(
        'https://serverless.roboflow.com/cells-itbmk/8?api_key=UzgZ82Wnlt92F2to1Za3&confidence=70&max_detections=1000',
      ),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: base64Image,
    );

    // Ver respuesta completa en consola
    print('📦 Respuesta Roboflow: ${response.body}');

    // Leer el resultado
    final data = jsonDecode(response.body);

    // Verificar que predictions exista
    if (data['predictions'] == null) {
      throw Exception('La API no devolvió predicciones: ${response.body}');
    }

    final int count = (data['predictions'] as List).length;

    setState(() {
      _cellCount = count;
      _isAnalyzing = false;
    });
  } catch (e) {
    print('❌ ERROR: $e');
    setState(() => _isAnalyzing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

  // ─── Diálogo para elegir fuente de imagen ───────────────────────────────────
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Seleccionar imagen',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SourceButton(
                  icon: Icons.photo_library_rounded,
                  label: 'Galería',
                  onTap: () {
                    Navigator.pop(context);
                    _pickFromGallery();
                  },
                ),
                _SourceButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Cámara',
                  onTap: () {
                    Navigator.pop(context);
                    _pickFromCamera();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        title: const Row(
          children: [
            Icon(Icons.biotech, color: Color(0xFF00B4D8)),
            SizedBox(width: 8),
            Text(
              'Cell Counter',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Vista previa de la imagen ──────────────────────────────────
            ImagePreview(
              image: _selectedImage,
              onTap: _showImageSourceDialog,
            ),
            const SizedBox(height: 20),

            // ── Botón de análisis ──────────────────────────────────────────
            if (_selectedImage != null)
              ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : _analyzeImage,
                icon: _isAnalyzing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.search_rounded),
                label: Text(_isAnalyzing ? 'Analizando...' : 'Contar células'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077B6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),

            const SizedBox(height: 20),

            // ── Tarjeta de resultado ───────────────────────────────────────
            if (_cellCount != null) ResultCard(count: _cellCount!),
          ],
        ),
      ),

      // ── Botón flotante para cargar imagen ─────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showImageSourceDialog,
        backgroundColor: const Color(0xFF0077B6),
        icon: const Icon(Icons.add_photo_alternate_rounded, color: Colors.white),
        label: const Text('Nueva imagen',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// ─── Widget auxiliar para los botones de fuente ─────────────────────────────
class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0077B6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF0077B6), width: 1),
            ),
            child: Icon(icon, color: const Color(0xFF00B4D8), size: 32),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
