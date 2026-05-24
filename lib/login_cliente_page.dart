import 'home_cliente_page.dart';
import 'package:flutter/material.dart';

class LoginClientePage extends StatefulWidget {
  const LoginClientePage({super.key});

  @override
  State<LoginClientePage> createState() => _LoginClientePageState();
}

class _LoginClientePageState extends State<LoginClientePage> {
  // Chave global para controlar e validar o formulário
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;

  final TextEditingController _nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Cores padronizadas com a Landing Page
    final Color bgColor = Colors.grey[50]!;
    const Color cardColor = Colors.white;
    const Color primaryGreen = Colors.green;
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
                        'Voltar',
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
                      borderRadius: BorderRadius.circular(24), // Bordas iguais a home
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
                        // Ícone superior (com Hero para futura animação)
                        Hero(
                          tag: 'client_icon',
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: primaryGreen,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Subtítulo
                        const Text(
                          'Entre com seu CPF ou crie sua conta.',
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
                              _buildTabButton('Entrar', true),
                              _buildTabButton('Cadastrar', false),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- FORMULÁRIO COM VALIDAÇÕES ---
                        Form(
                          key: _formKey,
                          // AnimatedSize faz o card crescer/encolher suavemente!
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Column(
                              children: [
                                if (!isLogin) ...[
                                  _buildTextField(
                                    label: 'Nome completo',
                                    bgColor: fieldColor,
                                    controller: _nomeController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Informe seu nome';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                ],
                                
                                _buildTextField(
                                  label: 'CPF',
                                  bgColor: fieldColor,
                                  hint: '000.000.000-00',
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Informe seu CPF';
                                    if (value.length < 11) return 'CPF inválido';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                if (!isLogin) ...[
                                  _buildTextField(
                                    label: 'Telefone',
                                    bgColor: fieldColor,
                                    hint: '(11) 99999-9999',
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Informe seu telefone';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                ],

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
                                // Pega o nome digitado. Se for login (campo oculto), usa um nome genérico provisório
                                String nomeDigitado = isLogin ? 'Tutor' : _nomeController.text.split(' ').first;

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeClientePage(nomeCliente: nomeDigitado),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              isLogin ? 'Entrar' : 'Criar conta',
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

  Widget _buildTabButton(String title, bool isLoginTab) {
    bool isActive = isLogin == isLoginTab;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isLogin = isLoginTab; // Muda a aba e dispara a animação
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.green : Colors.black54,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Color bgColor,
    String hint = '',
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    TextEditingController? controller, 
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(          
          controller: controller, 
          obscureText: isPassword,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black38),
            filled: true,
            fillColor: bgColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            errorStyle: const TextStyle(color: Colors.redAccent),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.green, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}