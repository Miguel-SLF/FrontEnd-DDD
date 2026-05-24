import 'package:flutter/material.dart';
import 'med_vet_ini.dart'; 
import 'agendar_consulta_page.dart';
import 'cadastrar_pet_page.dart';
import 'perfil_cliente_page.dart';


class HomeClientePage extends StatefulWidget {
  final String nomeCliente;

  // Recebemos o nome do cliente no construtor para personalizar a saudação
  const HomeClientePage({super.key, required this.nomeCliente});

  @override
  State<HomeClientePage> createState() => _HomeClientePageState();
}

class _HomeClientePageState extends State<HomeClientePage> {
  late String _nomeExibido;
  DateTime _dataSelecionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    _nomeExibido = widget.nomeCliente; // Inicializa com o que veio do login
  }
  Widget build(BuildContext context) {
    final Color bgColor = Colors.grey[50]!;
    const Color primaryGreen = Colors.green;
    const Color textPrimary = Colors.black87;
    const Color textSecondary = Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      // --- BARRA SUPERIOR (AppBar) ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: textPrimary),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.pets, color: primaryGreen, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'MedVet',
              style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _fazerLogout(context),
            icon: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
            label: const Text('Sair', style: TextStyle(color: Colors.redAccent)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      
      // --- MENU LATERAL (Drawer) ---
      drawer: _buildDrawer(context),

      // --- CORPO DA PÁGINA ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000), // Limita a largura em telas grandes
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Saudação
                const Text(
                  'Bem-vindo', 
                  style: TextStyle(
                    color: primaryGreen, 
                    fontSize: 16, 
                    fontWeight: FontWeight.w500
                  )
                ),
                const SizedBox(height: 4),
                Text(
                  'Olá, $_nomeExibido!',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimary),
                ),

                // Seção: Consultas Agendadas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Consultas agendadas',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Adicionado o redirecionamento aqui:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AgendarConsultaPage()),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Nova consulta'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Card de "Nenhuma consulta"
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Center(
                    child: Text(
                      'Você ainda não tem consultas agendadas.',
                      style: TextStyle(color: textSecondary),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Seção: Calendário
                Row(
                  children: const [
                    Icon(Icons.calendar_month, color: textSecondary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Meu calendário',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Container do Calendário + Detalhes do dia
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      // Calendário Nativo do Flutter
                      SizedBox(
                        width: 300,
                        child: CalendarDatePicker(
                          initialDate: _dataSelecionada,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          onDateChanged: (data) {
                            setState(() {
                              _dataSelecionada = data;
                            });
                          },
                        ),
                      ),
                      
                      // Resumo do dia selecionado
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('DIA SELECIONADO', style: TextStyle(fontSize: 12, color: textSecondary, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(
                                '${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary),
                              ),
                              const SizedBox(height: 24),
                              const Center(
                                child: Text('Nenhuma consulta neste dia.', style: TextStyle(color: textSecondary)),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Seção: Botões de Ação Inferiores
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildActionCard(
                      Icons.calendar_today, 
                      'Agendar Consulta', 
                      'Marque um horário com nossos veterinários.',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AgendarConsultaPage()));
                      }
                    ),
                    _buildActionCard(Icons.pets, 
                    'Cadastrar Pet', 
                    'Adicione um novo amigo à sua família.',
                    onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastrarPetPage()));
                      }
                    ),
                    _buildActionCard(Icons.person_outline, 
                    'Meus Dados', 
                    'Visualize e atualize seu cadastro.',
                    onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilClientePage()));
                      }
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  // Função para desenhar os 3 cards do rodapé
  Widget _buildActionCard(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return InkWell( // Transforma o card em um botão clicável
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
      width: 300, // Largura fixa para manter alinhado no Wrap
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green, size: 28),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  // Função para construir o Menu Lateral (Hamburger)
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.pets, color: Colors.white, size: 36),
                const SizedBox(height: 12),
                const Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          _buildDrawerItem(
            Icons.home_outlined, 
            'Home', 
            isActive: true, 
            onTap: () {
              Navigator.pop(context); // Apenas fecha o menu, já estamos na Home
            }
          ),
          _buildDrawerItem(
            Icons.calendar_today_outlined, 
            'Agendar Consulta', 
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AgendarConsultaPage()));
            }
          ),          
          _buildDrawerItem(
            Icons.pets_outlined, 
            'Cadastrar Pet', 
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastrarPetPage()));
            }
          ),
          _buildDrawerItem(
            Icons.person_outline, 
            'Meu Perfil', 
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const PerfilClientePage())
              ).then((novoNome) {
                if (novoNome != null && novoNome is String) {
                  setState(() {
                    _nomeExibido = novoNome;
                      }
                    );
                  }
                }
              );
            }
          ),
          const Divider(),
          _buildDrawerItem(
            Icons.logout, 
            'Sair', 
            isDestructive: true, 
            onTap: () => _fazerLogout(context)
          ),
        ],
      ),
    );
  }

  // Item da lista do Drawer
  Widget _buildDrawerItem(IconData icon, String title, {bool isActive = false, bool isDestructive = false, VoidCallback? onTap}) {
    final color = isDestructive ? Colors.redAccent : (isActive ? Colors.green : Colors.black87);
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      selected: isActive,
      selectedTileColor: Colors.green.shade50,
      onTap: onTap ?? () {},
    );
  }

  // Função de Logout centralizada
  void _fazerLogout(BuildContext context) {
    // pushAndRemoveUntil limpa o histórico de navegação, impedindo que o usuário volte com o botão do celular
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()),
      (route) => false,
    );
  }
}