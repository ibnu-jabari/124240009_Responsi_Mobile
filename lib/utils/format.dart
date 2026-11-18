/// Contoh: 109.95 -> "$109.95", 695 -> "$695.00"
String formatHarga(double nilai) {
  return '\$${nilai.toStringAsFixed(2)}';
}
