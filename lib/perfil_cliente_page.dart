// lib/perfil_cliente_page.dart
import 'package:flutter/material.dart';

class PerfilClientePage extends StatefulWidget {
  const PerfilClientePage({super.key});

  @override
  State<PerfilClientePage> createState() => _PerfilClientePageState();
}

class _PerfilClientePageState extends State<PerfilClientePage> {
  bool _isEditing = false;
  
  // Controladores com dados simulados
  final _nomeController = TextEditingController(text: 'Marina Silva');
  final _emailController = TextEditingController(text: 'marina.silva@email.com');
  final _telController = TextEditingController(text: '(14) 99999-9999');
  final _cpfController = TextEditingController(text: '123.456.789-00');
  final _cepController = TextEditingController(text: '17500-000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Meus Dados', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                const CircleAvatar(radius: 50, backgroundColor: Colors.green, child: Icon(Icons.person, size: 50, color: Colors.white)),
                const SizedBox(height: 24),
                
                // Formulário
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      _buildField('Nome Completo', _nomeController),
                      _buildField('E-mail', _emailController),
                      _buildField('Telefone', _telController),
                      _buildField('CPF', _cpfController),
                      _buildField('CEP', _cepController),
                      const SizedBox(height: 24),
                      
                      // Botões de Ação
                      SizedBox(
                        width: double.infinity,
                        child: _isEditing
                            ? ElevatedButton(
                                onPressed: () {
                                  setState(() => _isEditing = false);
                                  Navigator.pop(context, _nomeController.text);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dados salvos!')));
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                child: const Text('Salvar Alterações'),
                              )
                            : OutlinedButton(
                                onPressed: () => setState(() => _isEditing = true),
                                child: const Text('Editar Perfil'),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            enabled: _isEditing, // Só permite editar se _isEditing for true
            decoration: InputDecoration(
              filled: !_isEditing, 
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}