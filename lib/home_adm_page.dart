// lib/dashboard_adm_page.dart
import 'package:flutter/material.dart';
import 'med_vet_ini.dart'; // Para o logout

class HomeAdmPage extends StatelessWidget {
  const HomeAdmPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryOrange = Colors.orange;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Painel da Clínica', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LandingPage()), (route) => false),
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            label: const Text('Sair', style: TextStyle(color: Colors.redAccent)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // --- CARDS DE INFORMAÇÕES GERAIS ---
            Wrap(
              spacing: 16, runSpacing: 16,
              children: [
                _buildStatCard('Consultas', '1', Icons.calendar_today, primaryOrange),
                _buildStatCard('Pets', '2', Icons.pets, primaryOrange),
                _buildStatCard('Tutores', '2', Icons.person_outline, primaryOrange),
                _buildStatCard('Funcionários', '3', Icons.work_outline, primaryOrange),
              ],
            ),
            const SizedBox(height: 32),
            
            // --- TABELA DE FUNCIONÁRIOS ---
            _buildAdminSection(
              title: 'Equipe da clínica',
              icon: Icons.work_outline,
              child: _buildFuncionariosTable(),
            ),
            const SizedBox(height: 32),
            
            // --- TABELA DE CONSULTAS ---
            _buildAdminSection(
              title: 'Todas as consultas',
              icon: Icons.list_alt,
              child: _buildConsultasTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 200, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildAdminSection({required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: Colors.orange), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 16),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: child),
        ],
      ),
    );
  }

  // Tabela simplificada de Funcionários
  Widget _buildFuncionariosTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Nome')),
        DataColumn(label: Text('Cargo')),
        DataColumn(label: Text('E-mail')),
        DataColumn(label: Text('Ações')),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(Text('Dra. Helena')),
          const DataCell(Text('Veterinária')),
          const DataCell(Text('helena@verde.vet')),
          DataCell(Row(children: [IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: () {}), IconButton(icon: const Icon(Icons.delete, size: 18, color: Colors.red), onPressed: () {})])),
        ]),
      ],
    );
  }

  // Tabela simplificada de Consultas
  Widget _buildConsultasTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Data')),
        DataColumn(label: Text('Tutor')),
        DataColumn(label: Text('Pet')),
        DataColumn(label: Text('Status')),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(Text('21/05/2026')),
          const DataCell(Text('Marina Souza')),
          const DataCell(Text('Thor')),
          DataCell(Chip(label: const Text('Agendada', style: TextStyle(fontSize: 10)), backgroundColor: Colors.green.shade100)),
        ]),
      ],
    );
  }
}