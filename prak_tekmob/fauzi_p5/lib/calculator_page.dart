import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  static const _bg       = Color(0xFFFDF6EC);
  static const _brown    = Color(0xFF5C3D1E);
  static const _brownM   = Color(0xFF8B5E3C);
  static const _card     = Color(0xFFFFFAF3);
  static const _text     = Color(0xFF3D2B1A);
  static const _muted    = Color(0xFF8B6F55);
  static const _btnLight = Color(0xFFF5EDD8);
  static const _btnMid   = Color(0xFFE8D5B8);

  // ── State ─────────────────────────────────────────────────────────────────────
  String _display    = '0';
  String _expression = '';
  double _num1       = 0;
  String _operator   = '';
  bool   _newNum     = false;
  bool   _justCalc   = false;

  // ── Handlers ──────────────────────────────────────────────────────────────────

  void _onDigit(String d) {
    setState(() {
      if (_justCalc) {
        _display    = _fmt(double.parse(d));
        _expression = '';
        _justCalc   = false;
        _newNum     = false;
      } else if (_newNum) {
        _display = d;
        _newNum  = false;
      } else {
        // Bangun angka raw (tanpa titik), lalu reformat
        if (_display == '0') {
          _display = _fmt(double.parse(d));
        } else {
          // Ambil raw digits (hapus titik ribuan)
          final raw = _display.replaceAll('.', '').replaceAll(',', '.');
          // Jika sudah ada koma desimal, tambah digit ke bagian desimal saja
          if (raw.contains('.')) {
            final parts = raw.split('.');
            _display = _fmt(double.parse(parts[0])) + ',' + parts[1] + d;
          } else {
            final newRaw = raw + d;
            final v = double.tryParse(newRaw);
            _display = v != null ? _fmt(v) : _display;
          }
        }
      }
    });
  }

  void _onDecimal() {
    setState(() {
      if (_justCalc) {
        _display    = '0,';
        _expression = '';
        _justCalc   = false;
        _newNum     = false;
        return;
      }
      if (_newNum) { _display = '0,'; _newNum = false; return; }
      if (!_display.contains(',')) _display += ',';
    });
  }

  void _onOperator(String op) {
    setState(() {
      _num1     = _parse(_display);
      _operator = op;
      _newNum   = true;
      _justCalc = false;
      _expression = '${_fmt(_num1)} $op';
    });
  }

  void _onEquals() {
    if (_operator.isEmpty) return;
    setState(() {
      // Validasi 1: Input kosong
      // Operator dipilih tapi angka kedua belum diketik
      if (_newNum) {
        _expression = '${_fmt(_num1)} $_operator ???';
        _display    = 'Input kosong!';
        _operator   = '';
        _justCalc   = true;
        return;
      }

      final num2 = _parse(_display);

      // Validasi 2: Pembagian dengan nol
      if (_operator == '÷' && num2 == 0) {
        _expression = '${_fmt(_num1)} ÷ 0 =';
        _display    = 'Tidak bisa ÷ 0';
        _operator   = '';
        _justCalc   = true;
        return;
      }

      // Kalkulasi normal
      double result;
      switch (_operator) {
        case '+': result = _num1 + num2; break;
        case '−': result = _num1 - num2; break;
        case '×': result = _num1 * num2; break;
        case '÷': result = _num1 / num2; break;
        case '%': result = _num1 % num2; break;
        default:  result = num2;
      }
      _expression = '${_fmt(_num1)} $_operator ${_fmt(num2)} =';
      _display    = _fmt(result);
      _operator   = '';
      _justCalc   = true;
    });
  }

  void _onClear() {
    setState(() {
      _display    = '0';
      _expression = '';
      _num1       = 0;
      _operator   = '';
      _newNum     = false;
      _justCalc   = false;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_display.length <= 1 || _display == 'Error') {
        _display = '0';
      } else {
        // Hapus digit terakhir — lalu reformat
        // Ambil nilai numerik mentah dulu (hapus titik ribuan, ganti koma desimal)
        final raw = _display.replaceAll('.', '').replaceAll(',', '.');
        if (raw.length <= 1) {
          _display = '0';
        } else {
          final shorter = raw.substring(0, raw.length - 1);
          if (shorter == '-' || shorter.isEmpty) {
            _display = '0';
          } else {
            final v = double.tryParse(shorter);
            if (v == null) {
              _display = '0';
            } else {
              // Jika ada koma (sedang ketik desimal) jangan reformat
              if (shorter.contains('.')) {
                // Kembalikan dengan koma
                _display = shorter.replaceAll('.', ',');
              } else {
                _display = _fmt(v);
              }
            }
          }
        }
        if (_display == '-') _display = '0';
      }
    });
  }

  void _onToggleSign() {
    setState(() {
      final v = _parse(_display);
      _display = _fmt(v * -1);
    });
  }

  void _onPercent() {
    setState(() {
      final v = _parse(_display);
      _display = _fmt(v / 100);
    });
  }

  // Format angka dengan pemisah ribuan titik (.) dan desimal koma (,)
  // Contoh: 1000 → 1.000 | 1500.5 → 1.500,5
  String _fmt(double n) {
    if (n.isInfinite || n.isNaN) return 'Error';

    // Pisahkan bagian bulat dan desimal
    final bool isNegative = n < 0;
    final double absVal   = n.abs();

    String intPart;
    String decPart = '';

    if (n == n.roundToDouble() && absVal < 1e15) {
      // Angka bulat
      intPart = absVal.toInt().toString();
    } else {
      // Ada desimal — max 8 digit lalu hapus trailing 0
      final raw = absVal.toStringAsFixed(8)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
      final parts = raw.split('.');
      intPart = parts[0];
      if (parts.length > 1) decPart = parts[1];
    }

    // Tambah titik setiap 3 digit dari kanan
    final buf = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i != 0 && (intPart.length - i) % 3 == 0) buf.write('.');
      buf.write(intPart[i]);
    }

    final result = (isNegative ? '-' : '') +
        buf.toString() +
        (decPart.isNotEmpty ? ',$decPart' : '');
    return result;
  }

  // Parse string berformat (1.000,5) kembali ke double untuk kalkulasi
  double _parse(String s) {
    // Hapus titik pemisah ribuan, ganti koma desimal dengan titik
    final cleaned = s.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(cleaned) ?? 0;
  }

  double get _fontSize {
    if (_display.length > 12) return 28;
    if (_display.length > 9)  return 36;
    if (_display.length > 6)  return 44;
    return 54;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_rounded,
              color: _brown, size: 18),
        ),
        title: const Text(
          'Kalkulator',
          style: TextStyle(
            color: _text,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Display ──────────────────────────────────────────────────────────
            Expanded(
              flex: 3,
              child: _buildDisplay(),
            ),
            const SizedBox(height: 12),

            // ── Keypad ───────────────────────────────────────────────────────────
            Expanded(
              flex: 6,
              child: _buildKeypad(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Display ───────────────────────────────────────────────────────────────────

  Widget _buildDisplay() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _brown.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: _brown.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Ekspresi riwayat
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _expression,
              key: ValueKey(_expression),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                color: _muted,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Angka utama
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 120),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: Text(
              _display,
              key: ValueKey(_display),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: _fontSize,
                fontWeight: FontWeight.w900,
                color: _display == 'Error'
                    ? const Color(0xFFEF5350)
                    : _text,
                letterSpacing: -1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ── Keypad ────────────────────────────────────────────────────────────────────

  Widget _buildKeypad() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          // Row 1: AC  +/−  %  ÷
          Expanded(
            child: _Row4(
              children: [
                _Btn('AC',  _BtnT.fn,  _onClear),
                _Btn('+/−', _BtnT.fn,  _onToggleSign),
                _Btn('%',   _BtnT.fn,  _onPercent),
                _Btn('÷',   _BtnT.op,  () => _onOperator('÷'),
                    active: _operator == '÷'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Row 2: 7  8  9  ×
          Expanded(
            child: _Row4(
              children: [
                _Btn('7', _BtnT.num, () => _onDigit('7')),
                _Btn('8', _BtnT.num, () => _onDigit('8')),
                _Btn('9', _BtnT.num, () => _onDigit('9')),
                _Btn('×', _BtnT.op,  () => _onOperator('×'),
                    active: _operator == '×'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Row 3: 4  5  6  −
          Expanded(
            child: _Row4(
              children: [
                _Btn('4', _BtnT.num, () => _onDigit('4')),
                _Btn('5', _BtnT.num, () => _onDigit('5')),
                _Btn('6', _BtnT.num, () => _onDigit('6')),
                _Btn('−', _BtnT.op,  () => _onOperator('−'),
                    active: _operator == '−'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Row 4: 1  2  3  +
          Expanded(
            child: _Row4(
              children: [
                _Btn('1', _BtnT.num, () => _onDigit('1')),
                _Btn('2', _BtnT.num, () => _onDigit('2')),
                _Btn('3', _BtnT.num, () => _onDigit('3')),
                _Btn('+', _BtnT.op,  () => _onOperator('+'),
                    active: _operator == '+'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Row 5: 0 (2col)  .  ⌫
          Expanded(
            child: Row(
              children: [
                // Tombol 0 lebar 2
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => _onDigit('0'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _btnLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: _brown.withOpacity(0.1)),
                        ),
                        alignment: Alignment.centerLeft,
                        padding:
                        const EdgeInsets.only(left: 28),
                        child: Text(
                          '0',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _text,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: _buildSingleBtn(',', _BtnT.num, _onDecimal)),
                Expanded(child: _buildSingleBtn('⌫', _BtnT.fn, _onBackspace)),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Row 6: mod (%)  = (3col)
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => _onOperator('%'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _operator == '%'
                              ? Colors.white
                              : _btnMid,
                          borderRadius: BorderRadius.circular(20),
                          border: _operator == '%'
                              ? Border.all(
                              color: _brown.withOpacity(0.4))
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'mod',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _operator == '%'
                                  ? _brown
                                  : _brownM,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Tombol = lebar 3
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: _onEquals,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _brown,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          '=',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tombol single (untuk . dan ⌫ di row 5)
  Widget _buildSingleBtn(String label, _BtnT type, VoidCallback onTap) {
    Color bg;
    Color fg;
    switch (type) {
      case _BtnT.num: bg = _btnLight; fg = _text;   break;
      case _BtnT.op:  bg = _brown;    fg = Colors.white; break;
      case _BtnT.fn:  bg = _btnMid;   fg = _brownM; break;
    }
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
            border: type == _BtnT.num
                ? Border.all(color: _brown.withOpacity(0.1))
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Helper: Row 4 tombol ──────────────────────────────────────────────────────

class _Row4 extends StatelessWidget {
  final List<Widget> children;
  const _Row4({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children
          .map((c) => Expanded(child: c))
          .toList(),
    );
  }
}

// ── Tombol Kalkulator ─────────────────────────────────────────────────────────

enum _BtnT { num, op, fn }

class _Btn extends StatelessWidget {
  final String label;
  final _BtnT type;
  final VoidCallback onTap;
  final bool active;

  static const _brown   = Color(0xFF5C3D1E);
  static const _brownM  = Color(0xFF8B5E3C);
  static const _text    = Color(0xFF3D2B1A);
  static const _btnLight = Color(0xFFF5EDD8);
  static const _btnMid   = Color(0xFFE8D5B8);

  const _Btn(this.label, this.type, this.onTap,
      {this.active = false});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    if (type == _BtnT.op && active) {
      bg = Colors.white;
      fg = _brown;
    } else {
      switch (type) {
        case _BtnT.num: bg = _btnLight; fg = _text;        break;
        case _BtnT.op:  bg = _brown;    fg = Colors.white; break;
        case _BtnT.fn:  bg = _btnMid;   fg = _brownM;      break;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
            border: type == _BtnT.num
                ? Border.all(color: _brown.withOpacity(0.1))
                : (active
                ? Border.all(color: _brown.withOpacity(0.35))
                : null),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: label.length > 2 ? 15 : 22,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}