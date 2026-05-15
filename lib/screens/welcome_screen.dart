import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'semestres_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              const Spacer(),

              const Icon(Icons.school, size: 80, color: AppTheme.primary),

              const SizedBox(height: 16),

              const Text(
                'ClassShare',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Organize e compartilhe registros fotográficos\n'
                'das suas aulas por semestre e disciplina.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 48),

              const _InfoItem(
                icon: Icons.calendar_month_outlined,
                label: 'Organize por semestres',
              ),

              const SizedBox(height: 16),

              const _InfoItem(
                icon: Icons.class_outlined,
                label: 'Separe por disciplina',
              ),

              const SizedBox(height: 16),

              const _InfoItem(
                icon: Icons.photo_library_outlined,
                label: 'Registre com fotos e descrições',
              ),

              const SizedBox(height: 32),

              Text(
                'Projeto acadêmico desenvolvido por:',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Erick Alves da Silva\n'
                'Fábio da Rocha e Silva Alcântara\n'
                'Felipe Choiti Yonaha\n'
                'Lucas Ancilon Pavão\n'
                'Paloma Oliveira Cordeiro',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SemestresScreen()),
                  ),
                  child: const Text(
                    'Começar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primary, size: 22),
        ),

        const SizedBox(width: 16),

        Text(label, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
