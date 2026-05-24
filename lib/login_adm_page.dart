import 'package:flutter/material.dart';
import 'home_adm_page.dart';

class LoginAdmPage extends StatefulWidget {
  const LoginAdmPage({super.key});

  @override
  State<LoginAdmPage> createState() => _LoginAdmPageState();
}

class _LoginAdmPageState extends State<LoginAdmPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  
  // Variável para guardar o cargo selecionado na lista
  String? _cargoSelecionado;

  // Lista de cargos disponíveis na clínica
  final List<String> _cargos = [
    'Veterinário(a)',
    'Enfermeiro(a) Veterinário(a)',
    'Recepcionista',
    'Gerente da Clínica',
    'Cirurgião(ã)'
  ];

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Colors.grey[50]!;
    const Color cardColor = Colors.white;
    const Color primaryColor = Colors.orange; // Laranja/Creme para diferenciar do verde do cliente
    final Color fieldColor = Colors.grey.shade100;
    const Color textPrimary = Colors.black87;
    const Color textSecondary = Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BOTÃO DE VOLTAR ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.arrow_back, color: textSecondary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Voltar', // Alterado conforme seu feedback
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // --- CARD CENTRAL ---
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Ícone do Admin
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings_outlined,
                            color: primaryColor,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        const Text(
                          'Acesso Restrito',
                          style: TextStyle(
                            fontSize: 14,
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- TOGGLE (Entrar / Cadastrar) ---
                        Container(
                          height: 48,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: fieldColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              _buildTabButton('Entrar', true, primaryColor),
                              _buildTabButton('Cadastrar', false, primaryColor),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- FORMULÁRIO ---
                        Form(
                          key: _formKey,
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Column(
                              children: [
                                // CAMPOS EXCLUSIVOS DE CADASTRO
                                if (!isLogin) ...[
                                  _buildTextField(
                                    label: 'Nome completo',
                                    bgColor: fieldColor,
                                    validator: (value) => value!.isEmpty ? 'Informe seu nome' : null,
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Email com validação @unimar
                                  _buildTextField(
                                    label: 'Email corporativo',
                                    bgColor: fieldColor,
                                    hint: 'nome@unimar.br',
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Informe seu email';
                                      if (!value.toLowerCase().contains('@unimar')) {
                                        return 'Acesso negado: Use um email @unimar';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Dropdown de Cargos
                                  _buildDropdownCargo(bgColor),
                                  const SizedBox(height: 16),
                                ],
                                
                                // CAMPOS COMUNS (LOGIN E CADASTRO)
                                _buildTextField(
                                  label: 'CPF',
                                  bgColor: fieldColor,
                                  hint: '000.000.000-00',
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Informe o CPF';
                                    if (value.length < 11) return 'CPF inválido';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                _buildTextField(
                                  label: 'Senha',
                                  bgColor: fieldColor,
                                  isPassword: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Informe sua senha';
                                    if (value.length < 6) return 'A senha deve ter no mínimo 6 caracteres';
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),

                        // --- BOTÃO DE AÇÃO ---
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HomeAdmPage()),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              isLogin ? 'Entrar' : 'Cadastrar Servidor',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildTabButton(String title, bool isLoginTab, Color activeColor) {
    bool isActive = isLogin == isLoginTab;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isLogin = isLoginTab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? activeColor : Colors.black54,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Novo componente: Dropdown para os cargos
  Widget _buildDropdownCargo(Color bgColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cargo na Clínica',
          style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _cargoSelecionado,
          hint: const Text('Selecione uma função', style: TextStyle(color: Colors.black38)),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          decoration: InputDecoration(
            filled: true,
            fillColor: bgColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            errorStyle: const TextStyle(color: Colors.redAccent),
          ),
          items: _cargos.map((String cargo) {
            return DropdownMenuItem<String>(
              value: cargo,
              child: Text(cargo, style: const TextStyle(color: Colors.black87)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _cargoSelecionado = newValue;
            });
          },
          validator: (value) => value == null ? 'Por favor, selecione um cargo' : null,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required Color bgColor,
    String hint = '',
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: isPassword,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            filled: true,
            fillColor: bgColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            errorStyle: const TextStyle(color: Colors.redAccent),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.orange, width: 1), // Cor de foco laranja
            ),
          ),
        ),
      ],
    );
  }
}
