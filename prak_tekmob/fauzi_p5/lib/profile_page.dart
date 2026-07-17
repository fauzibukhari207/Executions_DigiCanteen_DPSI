import 'package:flutter/material.dart';
import 'calculator_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _bg     = Color(0xFFFDF6EC);
  static const _brown  = Color(0xFF5C3D1E);
  static const _brownM = Color(0xFF8B5E3C);
  static const _card   = Color(0xFFFFFAF3);
  static const _text   = Color(0xFF3D2B1A);
  static const _muted  = Color(0xFF8B6F55);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: Text(
          'Profile Card',
          style: TextStyle(
            color: _text,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        // Tombol navigasi ke Kalkulator
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const CalculatorPage()),
            ),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _brown,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('🧮',
                      style: TextStyle(fontSize: 13)),
                  SizedBox(width: 5),
                  Text(
                    'Kalkulator',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildStatsRow(),
            const SizedBox(height: 16),
            _buildInfoSection(),
            const SizedBox(height: 16),
            _buildSkillSection(),
            const SizedBox(height: 16),
            _buildContactSection(),
            const SizedBox(height: 20),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  // ── Profile Header ────────────────────────────────────────────────────────────

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _brown.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: _brown.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Foto Profil (Asset Image) ─────────────────────────────────────────
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: _brown.withOpacity(0.3), width: 3),
                ),
                child: ClipOval(
                  child: Image.asset(
                    // Ganti dengan nama file foto kamu di assets/images/
                    'assets/images/IMG_8745.jpg',
                    fit: BoxFit.cover,
                    // Fallback jika gambar belum ada
                    errorBuilder: (ctx, error, _) => Container(
                      color: _brown.withOpacity(0.1),
                      child: Center(
                        child: Text(
                          '👨‍💻',
                          style: const TextStyle(fontSize: 44),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Nama
          Text(
            'Muhammad Fauzi Al Bukhari',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: _text,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Mahasiswa Sistem Informasi',
            style: TextStyle(
              fontSize: 13,
              color: _muted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Badge baris
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Badge(label: '🎓 S1 Sistem Informasi', color: _brown),
              const SizedBox(width: 8),
              _Badge(label: '📍 Yogyakarta', color: _brownM),
            ],
          ),
        ],
      ),
    );
  }

  // ── Stats Row ─────────────────────────────────────────────────────────────────

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
            child:
            _StatCard(value: '3.55', label: 'IPK', emoji: '📊')),
        const SizedBox(width: 10),
        Expanded(
            child: _StatCard(
                value: '4', label: 'Semester', emoji: '📅')),
        const SizedBox(width: 10),
        Expanded(
            child:
            _StatCard(value: '12', label: 'Proyek', emoji: '🛠')),
      ],
    );
  }

  // ── Info Section ──────────────────────────────────────────────────────────────

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _brown.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Informasi', emoji: '📋'),
          const SizedBox(height: 14),
          _InfoRow(
              icon: Icons.badge_rounded,
              label: 'NIM',
              value: '2400016073'),
          _DividerLine(),
          _InfoRow(
              icon: Icons.school_rounded,
              label: 'Universitas',
              value: 'Universitas Ahmad Dahlan'),
          _DividerLine(),
          _InfoRow(
              icon: Icons.calendar_today_rounded,
              label: 'Angkatan',
              value: '2024'),
          _DividerLine(),
          _InfoRow(
              icon: Icons.email_rounded,
              label: 'Email',
              value: '2400016073@webmail.uad.ac.id'),
          _DividerLine(),
          _InfoRow(
              icon: Icons.phone_rounded,
              label: 'No. HP',
              value: '+62 823 8449 8636'),
        ],
      ),
    );
  }

  // ── Skill Section ─────────────────────────────────────────────────────────────

  Widget _buildSkillSection() {
    final skills = [
      {'name': 'Flutter',      'level': 0.80},
      {'name': 'Dart',         'level': 0.75},
      {'name': 'UI/UX Design', 'level': 0.65},
      {'name': 'Firebase',     'level': 0.55},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _brown.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Keahlian', emoji: ''),
          const SizedBox(height: 14),
          ...skills.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      s['name'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _text,
                      ),
                    ),
                    Text(
                      '${((s['level'] as double) * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: _brown,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: s['level'] as double,
                    minHeight: 8,
                    backgroundColor:
                    _brown.withOpacity(0.1),
                    valueColor:
                    AlwaysStoppedAnimation<Color>(_brown),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ── Contact Section ───────────────────────────────────────────────────────────

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _brown.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Sosial Media', emoji: '🌐'),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                  child: _SocialChip(
                      icon: '📱', label: 'WhatsApp')),
              const SizedBox(width: 8),
              Expanded(
                  child: _SocialChip(
                      icon: '💼', label: 'LinkedIn')),
              const SizedBox(width: 8),
              Expanded(
                  child:
                  _SocialChip(icon: '🐙', label: 'GitHub')),
            ],
          ),
        ],
      ),
    );
  }

  // ── Action Buttons ────────────────────────────────────────────────────────────

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // ElevatedButton — Buka Kalkulator
        ElevatedButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const CalculatorPage()),
          ),
          icon: const Text('🧮',
              style: TextStyle(fontSize: 16)),
          label: const Text(
            'Buka Kalkulator',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _brown,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

// ── Reusable Widgets ──────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String emoji;
  const _StatCard({
    required this.value,
    required this.label,
    required this.emoji,
  });

  static const _brown = Color(0xFF5C3D1E);
  static const _muted = Color(0xFF8B6F55);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _brown.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: _brown,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: _muted),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String emoji;
  const _SectionTitle(
      {required this.title, required this.emoji});

  static const _text = Color(0xFF3D2B1A);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: _text,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  static const _brown = Color(0xFF5C3D1E);
  static const _text  = Color(0xFF3D2B1A);
  static const _muted = Color(0xFF8B6F55);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _brown.withOpacity(0.08),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 16, color: _brown),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: _muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: _text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: const Color(0xFF5C3D1E).withOpacity(0.08),
    );
  }
}

class _SocialChip extends StatelessWidget {
  final String icon;
  final String label;
  const _SocialChip({required this.icon, required this.label});

  static const _brown = Color(0xFF5C3D1E);
  static const _text  = Color(0xFF3D2B1A);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: _brown.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _brown.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: _text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}