// riwayat_dm_widget.dart

import 'package:flutter/material.dart';

class RiwayatDMKeluargaDropdown extends StatefulWidget {
  final void Function(bool) onChanged;
  final String? initialValue;

  const RiwayatDMKeluargaDropdown({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<RiwayatDMKeluargaDropdown> createState() =>
      _RiwayatDMKeluargaDropdownState();
}

class _RiwayatDMKeluargaDropdownState
    extends State<RiwayatDMKeluargaDropdown> {
  final List<String> options = [
    'Tidak Ada',
    'Diabetes Melitus',
    'Diabetes Gestasional',
  ];
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.initialValue;
  }
  @override
void didUpdateWidget(covariant RiwayatDMKeluargaDropdown oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (widget.initialValue != oldWidget.initialValue) {
    setState(() {
      selectedOption = widget.initialValue;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEBF0FF)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedOption,
          hint: Row(
            children: const [
              Icon(Icons.family_restroom, color: Color(0xFF9098B1)),
              SizedBox(width: 8),
              Text(
                'Riwayat DM Keluarga',
                style: TextStyle(
                  color: Color(0xFF9098B1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF9098B1)),
          isExpanded: true,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF9098B1),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedOption = value;
              widget.onChanged(value != 'Tidak Ada');
            });
          },
        ),
      ),
    );
  }
}
