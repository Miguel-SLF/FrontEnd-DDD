import 'package:flutter/material.dart';

class CadastrarPetPage extends StatefulWidget {
  const CadastrarPetPage({super.key});

  @override
  State<CadastrarPetPage> createState() => _CadastrarPetPageState();
}

class _CadastrarPetPageState extends State<CadastrarPetPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _idadeController = TextEditingController();
  String? _especieSelecionada;

  final List<String> _especies = ['Cão', 'Gato', 'Ave', 'Réptil', 'Outro'];
  
  final List<Map<String, String>> _meusPets = []; 

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Colors.green;
    final Color fieldColor = Colors.grey.shade100;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Cadastrar Pet', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Formulário de Cadastro
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildTextField('Nome', _nomeController, fieldColor)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildDropdown(fieldColor)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildTextField('Raça', _racaController, fieldColor)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildTextField('Idade (anos)', _idadeController, fieldColor, isNumber: true)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _meusPets.add({
                                    'nome': _nomeController.text,
                                    'especie': _especieSelecionada!,
                                    'raca': _racaController.text,
                                    'idade': _idadeController.text
                                  });
                                  _formKey.currentState!.reset();
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Cadastrar pet'),
                            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text('Meus pets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                // Lista de Pets
                ..._meusPets.map((pet) => _buildPetCard(pet)).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, Color bgColor, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          validator: (val) => val!.isEmpty ? 'Campo obrigatório' : null,
          decoration: InputDecoration(filled: true, fillColor: bgColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
        ),
      ],
    );
  }

  Widget _buildDropdown(Color bgColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Espécie', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _especieSelecionada,
          items: _especies.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (val) => setState(() => _especieSelecionada = val),
          decoration: InputDecoration(filled: true, fillColor: bgColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
          validator: (val) => val == null ? 'Selecione a espécie' : null,
        ),
      ],
    );
  }

  Widget _buildPetCard(Map<String, String> pet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.pets, color: Colors.white)),
        title: Text(pet['nome']!, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${pet['especie']} • ${pet['raca']} • ${pet['idade']}a'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => setState(() => _meusPets.remove(pet)),
        ),
      ),
    );
  }
}