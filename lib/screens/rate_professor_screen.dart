import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/professor.dart';
import '../services/mock_data_service.dart';

/// Pantalla para calificar y evaluar a un profesor
class RateProfessorScreen extends StatefulWidget {
  final Professor professor;

  const RateProfessorScreen({
    super.key,
    required this.professor,
  });

  @override
  State<RateProfessorScreen> createState() => _RateProfessorScreenState();
}

class _RateProfessorScreenState extends State<RateProfessorScreen> {
  // Calificaciones por categoría
  int _claridadRating = 0;
  int _interaccionRating = 0;
  int _rigorAcademicoRating = 0;

  // Controladores de texto
  final TextEditingController _destacaController = TextEditingController();
  final TextEditingController _comentariosController = TextEditingController();

  // Límites de caracteres
  static const int _destacaMaxLength = 150;
  static const int _comentariosMaxLength = 500;

  @override
  void dispose() {
    _destacaController.dispose();
    _comentariosController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    return _claridadRating > 0 && 
           _interaccionRating > 0 && 
           _rigorAcademicoRating > 0;
  }

  void _submitRating() {
    if (!_canSubmit) return;

    // Calcular promedio de las tres categorías
    final averageRating = (_claridadRating + _interaccionRating + _rigorAcademicoRating) / 3;
    
    // Crear comentario completo
    String fullComment = '';
    if (_destacaController.text.trim().isNotEmpty) {
      fullComment += 'Destaca: ${_destacaController.text.trim()}';
    }
    if (_comentariosController.text.trim().isNotEmpty) {
      if (fullComment.isNotEmpty) fullComment += '\n\n';
      fullComment += _comentariosController.text.trim();
    }

    // Agregar la reseña
    final currentUser = MockDataService.getCurrentUser();
    MockDataService.addReviewToProfessor(
      professorId: widget.professor.id,
      userId: currentUser.id,
      userName: currentUser.name,
      rating: averageRating.round(),
      comment: fullComment.isEmpty ? 'Sin comentarios adicionales.' : fullComment,
    );

    // Navegar a la pantalla de confirmación
    Navigator.pushNamed(context, '/rating-completed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header con gradiente
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryOrange, AppColors.primaryGold],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Fila con botón de retroceder y título
                    Row(
                      children: [
                        // Botón de retroceder
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.textLight,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Título centrado
                        const Expanded(
                          child: Text(
                            'Es tu turno de calificar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Espacio vacío para mantener centrado el título
                        const SizedBox(width: 44), // Ancho del botón + padding
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Contenido principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información del profesor
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Foto del profesor
                        Container(
                          width: 120,
                          height: 160,
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'Foto',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.mediumGray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 20),
                        
                        // Información del profesor
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              
                              // Nombre del profesor
                              Text(
                                widget.professor.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // Departamento
                              Text(
                                widget.professor.department,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Sección de calificación por categorías
                    _buildRatingCategory('Claridad', _claridadRating, (rating) {
                      setState(() {
                        _claridadRating = rating;
                      });
                    }),
                    
                    const SizedBox(height: 24),
                    
                    _buildRatingCategory('Interacción', _interaccionRating, (rating) {
                      setState(() {
                        _interaccionRating = rating;
                      });
                    }),
                    
                    const SizedBox(height: 24),
                    
                    _buildRatingCategory('Rigor Académico', _rigorAcademicoRating, (rating) {
                      setState(() {
                        _rigorAcademicoRating = rating;
                      });
                    }),
                    
                    const SizedBox(height: 40),
                    
                    // ¿Qué destacas del profesor?
                    const Text(
                      '¿Qué destacas del profesor?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextField(
                      controller: _destacaController,
                      maxLength: _destacaMaxLength,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Escribe lo que más destacas...',
                        hintStyle: const TextStyle(color: AppColors.textSecondary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.lightGray),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.lightGray),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryOrange),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        counterStyle: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Comentarios
                    const Text(
                      'Comentarios',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextField(
                      controller: _comentariosController,
                      maxLength: _comentariosMaxLength,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Comparte tu experiencia con este profesor...',
                        hintStyle: const TextStyle(color: AppColors.textSecondary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.lightGray),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.lightGray),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryOrange),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        counterStyle: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Botón Enviar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _canSubmit ? _submitRating : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canSubmit 
                            ? AppColors.primaryOrange 
                            : AppColors.mediumGray,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Enviar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCategory(String title, int currentRating, Function(int) onRatingChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Título de la categoría
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        
        // Estrellas
        Row(
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            return GestureDetector(
              onTap: () => onRatingChanged(starIndex),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Icon(
                  Icons.star,
                  size: 32,
                  color: starIndex <= currentRating 
                    ? AppColors.star 
                    : AppColors.lightGray,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
