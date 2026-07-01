import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReadingProgressPage extends StatefulWidget {
  final String mangaTitle;

  const ReadingProgressPage({
    super.key,
    required this.mangaTitle,
  });

  @override
  State<ReadingProgressPage> createState() => _ReadingProgressPageState();
}

class _ReadingProgressPageState extends State<ReadingProgressPage> {
  final TextEditingController _readController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  double _progress = 0;
  double _percentage = 0;

  void _calculateProgress() {
    int read = int.tryParse(_readController.text) ?? 0;
    int total = int.tryParse(_totalController.text) ?? 0;

    if (total > 0 && read <= total) {
      setState(() {
        _progress = read / total;
        _percentage = (_progress * 100);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Informe valores válidos!",
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _readController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Acompanhar Leitura",
          style: GoogleFonts.modak(),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF7E57C2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Text(
              widget.mangaTitle,
              style: GoogleFonts.modak(
                fontSize: 30,
                color: const Color(0xFF7E57C2),
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: _readController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Capítulos lidos",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _totalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Total de capítulos",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: _calculateProgress,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7E57C2),
              ),
              child: const Text(
                "Calcular progresso",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 35),

            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _progress),
              duration: const Duration(milliseconds: 900),
              builder: (context, value, child) {
                return Column(
                  children: [
                    LinearProgressIndicator(
                      value: value,
                      minHeight: 18,
                      borderRadius: BorderRadius.circular(15),
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF7E57C2),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "${_percentage.toStringAsFixed(1)}%",
                      style: GoogleFonts.modak(
                        fontSize: 28,
                        color: const Color(0xFF7E57C2),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}