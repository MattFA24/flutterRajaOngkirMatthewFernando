part of 'widgets.dart';

// Function to trigger the modal
void showBottomSheetCost(BuildContext context, Costs cost) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _ShippingDetailPopup(cost: cost);
    },
  );
}

class _ShippingDetailPopup extends StatelessWidget {
  final Costs cost;
  const _ShippingDetailPopup({required this.cost});

  @override
  Widget build(BuildContext context) {
    // Currency Formatter (Rp264.000,00)
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 2,
    );

    // Helper to format ETD (e.g. "6" -> "6 hari" or "1-2 Days" -> "1-2 hari")
    String formatEtd(String? etd) {
      if (etd == null || etd.isEmpty) return '-';
      String clean = etd
          .toLowerCase()
          .replaceAll('days', '')
          .replaceAll('day', '')
          .replaceAll('hari', '')
          .trim();
      return "$clean hari";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Grey Drag Handle
          Center(
            child: Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // 2. Header (Icon + Title + Close Button)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blue Icon Circle
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_shipping,
                  color: Style.blue800,
                  size: 26,
                ),
              ),
              const SizedBox(width: 15),

              // Title: Courier Name & Service
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cost.name ?? "Courier",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Style.blue800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cost.service ?? "-",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Close Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 20),

          // 3. Details List (Aligned)
          _buildDetailRow("Nama Kurir", cost.name ?? "-"),
          _buildDetailRow("Kode", cost.code ?? "-"),
          _buildDetailRow("Layanan", cost.service ?? "-"),
          _buildDetailRow("Deskripsi", cost.description ?? "-"),
          _buildDetailRow("Biaya", currencyFormatter.format(cost.cost ?? 0)),
          _buildDetailRow("Estimasi\nPengiriman", formatEtd(cost.etd)),

          const SizedBox(height: 30), // Bottom padding
        ],
      ),
    );
  }

  // Helper widget for specific row alignment
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label Column (Fixed width aligns the colons)
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // The Colon
          const Text(
            ":  ",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          // Value Column
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
