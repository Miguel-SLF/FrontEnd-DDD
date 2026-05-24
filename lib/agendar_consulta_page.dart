import 'package:flutter/material.dart';
import 'cadastrar_pet_page.dart';

class AgendarConsultaPage extends StatefulWidget {
  const AgendarConsultaPage({super.key});

  @override
  State<AgendarConsultaPage> createState() => _AgendarConsultaPageState();
}

class _AgendarConsultaPageState extends State<AgendarConsultaPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores e Variáveis de Estado
  String? _petSelecionado;
  String? _vetSelecionado;
  DateTime? _dataSelecionada;
  String? _horarioSelecionado;
  final TextEditingController _motivoController = TextEditingController();

  final List<String> _meusPets = []; // Começa vazio, pois o usuário ainda não cadastrou nada
  final List<String> _veterinarios = [];
  final List<String> _horariosDisponiveis = ['09:00', '10:00', '14:00', '15:30', '16:00'];

  final List<Map<String, dynamic>> _consultasFuturas = []; 

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
  }

  // Função para abrir o calendário nativo
  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Não permite agendar no passado
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (dataEscolhida != null && dataEscolhida != _dataSelecionada) {
      setState(() {
        _dataSelecionada = dataEscolhida;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Colors.grey[50]!;
    const Color cardColor = Colors.white;
    const Color primaryGreen = Colors.green;
    final Color fieldColor = Colors.grey.shade100;
    const Color textPrimary = Colors.black87;
    const Color textSecondary = Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: textPrimary),
        title: const Text('Agendar Consulta', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800), // Limita a largura para telas grandes
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Agendar Consulta',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textPrimary),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Escolha o pet, o veterinário e o melhor horário.',
                  style: TextStyle(fontSize: 16, color: textSecondary),
                ),
                const SizedBox(height: 32),

                // --- FORMULÁRIO DE AGENDAMENTO ---
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // LINHA 1: Pet e Veterinário
                        Row(
                          children: [
                            Expanded(
                              child: _meusPets.isEmpty
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Pet', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 8),
                                        // Botão que redireciona para a página de cadastro
                                        OutlinedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context, 
                                              MaterialPageRoute(builder: (context) => const CadastrarPetPage())
                                            ).then((_) {
                                              setState(() {}); 
                                            });
                                          },
                                          icon: const Icon(Icons.add, color: Colors.green),
                                          label: const Text('Cadastrar pet', style: TextStyle(color: Colors.green)),
                                          style: OutlinedButton.styleFrom(
                                            minimumSize: const Size(double.infinity, 50),
                                          ),
                                        ),
                                      ],
                                    )
                                  : _buildDropdown(
                                      label: 'Pet',
                                      hint: 'Selecione',
                                      value: _petSelecionado,
                                      items: _meusPets,
                                      bgColor: fieldColor,
                                      onChanged: (val) => setState(() => _petSelecionado = val),
                                    ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _veterinarios.isEmpty
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Veterinário(a)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 8),
                                        Container(
                                          height: 50,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          decoration: BoxDecoration(color: fieldColor, borderRadius: BorderRadius.circular(8)),
                                          child: const Text('Nenhum profissional disponível', style: TextStyle(color: Colors.grey)),
                                        ),
                                      ],
                                    )
                                  : _buildDropdown(
                                      label: 'Veterinário(a)',
                                      hint: 'Sem preferência',
                                      value: _vetSelecionado,
                                      items: _veterinarios,
                                      bgColor: fieldColor,
                                      onChanged: (val) => setState(() => _vetSelecionado = val),
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // LINHA 2: Data e Horário
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selecionarData(context),
                                child: AbsorbPointer( // Impede o teclado de abrir, forçando o clique no GestureDetector
                                  child: _buildTextField(
                                    label: 'Data',
                                    hint: _dataSelecionada == null 
                                        ? 'dd/mm/aaaa' 
                                        : '${_dataSelecionada!.day.toString().padLeft(2, '0')}/${_dataSelecionada!.month.toString().padLeft(2, '0')}/${_dataSelecionada!.year}',
                                    bgColor: fieldColor,
                                    icon: Icons.calendar_today,
                                    validator: (val) => _dataSelecionada == null ? 'Escolha uma data' : null,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdown(
                                label: 'Horário',
                                hint: 'Selecione',
                                value: _horarioSelecionado,
                                items: _horariosDisponiveis,
                                bgColor: fieldColor,
                                onChanged: (val) => setState(() => _horarioSelecionado = val),
                                validator: (val) => val == null ? 'Selecione um horário' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // LINHA 3: Motivo
                        _buildTextField(
                          label: 'Motivo',
                          hint: 'Check-up, vacinação...',
                          bgColor: fieldColor,
                          controller: _motivoController,
                          maxLines: 3,
                          validator: (val) => val == null || val.isEmpty ? 'Descreva o motivo' : null,
                        ),
                        const SizedBox(height: 32),

                        // BOTÃO AGENDAR
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Se tudo estiver preenchido corretamente, salva a consulta
                              setState(() {
                                _consultasFuturas.add({
                                  'pet': _petSelecionado,
                                  'vet': _vetSelecionado ?? 'Sem preferência',
                                  'data': '${_dataSelecionada!.day.toString().padLeft(2, '0')}/${_dataSelecionada!.month.toString().padLeft(2, '0')}/${_dataSelecionada!.year}',
                                  'horario': _horarioSelecionado,
                                  'motivo': _motivoController.text,
                                  'status': 'agendada'
                                });
                                // Limpa o formulário após agendar
                                _formKey.currentState!.reset();
                                _petSelecionado = null;
                                _vetSelecionado = null;
                                _dataSelecionada = null;
                                _horarioSelecionado = null;
                                _motivoController.clear();
                              });
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Consulta agendada com sucesso!'), backgroundColor: Colors.green),
                              );
                            }
                          },
                          icon: const Icon(Icons.calendar_month),
                          label: const Text('Agendar consulta', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // --- ÁREA DE MINHAS CONSULTAS (Só aparece se houver itens na lista) ---
                if (_consultasFuturas.isNotEmpty) ...[
                  const Text(
                    'Minhas consultas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
                  ),
                  const SizedBox(height: 16),
                  
                  // Gera um card para cada consulta na lista
                  ..._consultasFuturas.map((consulta) => _buildConsultaCard(consulta, cardColor, textPrimary, textSecondary)).toList(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Color bgColor,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Colors.black38)),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          decoration: InputDecoration(
            filled: true,
            fillColor: bgColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            errorStyle: const TextStyle(color: Colors.redAccent),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.black87)),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required Color bgColor,
    TextEditingController? controller,
    int maxLines = 1,
    IconData? icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            suffixIcon: icon != null ? Icon(icon, color: Colors.black38, size: 20) : null,
            filled: true,
            fillColor: bgColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            errorStyle: const TextStyle(color: Colors.redAccent),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.green, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConsultaCard(Map<String, dynamic> consulta, Color cardColor, Color textPrimary, Color textSecondary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${consulta['pet']} • ${consulta['vet']}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  '${consulta['data']} às ${consulta['horario']}',
                  style: TextStyle(fontSize: 14, color: textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  consulta['motivo'],
                  style: TextStyle(fontSize: 14, color: textSecondary),
                ),
              ],
            ),
          ),
          
          // Área dos botões da direita (Status e Lixeira)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  consulta['status'],
                  style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              
              // BOTÃO CANCELAR (Ícone de Lixeira Vermelha)
              IconButton(
                onPressed: () {
                  setState(() {
                    // Remove essa consulta específica da lista interna
                    _consultasFuturas.remove(consulta);
                  });
                  
                  // Mostra um aviso rápido confirmando que foi cancelado
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Consulta cancelada.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                },
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                tooltip: 'Cancelar consulta',
              ),
            ],
          )
        ],
      ),
    );
  }
}