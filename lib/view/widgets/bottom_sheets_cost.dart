part of 'widgets.dart';

// Function to trigger the bottom sheet
void showBottomSheetCost(BuildContext context, Costs cost) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _BottomSheetCostContent(cost: cost);
    },
  );
}

class _BottomSheetCostContent extends StatelessWidget {
  final Costs cost;
  const _BottomSheetCostContent({required this.cost});

  @override
  Widget build(BuildContext context) {
    // 1. Format Currency
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // 2. Format ETD (Clean "1-2 Days" to "1-2 Hari")
    String formatEtd(String? etd) {
      if (etd == null || etd.isEmpty) return '-';
      String cleanEtd = etd.replaceAll('day', '').replaceAll('days', '').replaceAll('hari', '').trim();
      return "$cleanEtd Hari";
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Takes only strictly needed height
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grey Handle Bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- HEADER: Service Name ---
          Text(
            "Service Detail",
            style: TextStyle(
              color: Style.grey500, // Uses your Style class
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            // Shows "JNE - REG" or just "REG" depending on your data preference
            "${cost.name} - ${cost.service}", 
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          const SizedBox(height: 24),
          const Divider(), // Thin line separator
          const SizedBox(height: 16),

          // --- BODY: Description ---
          Text(
            "Description",
            style: TextStyle(
              color: Style.grey500,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cost.description ?? "-", 
            style: const TextStyle(
              fontSize: 16,
              height: 1.5, // Better line spacing for reading
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // --- FOOTER: Price & ETD Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Cost", style: TextStyle(color: Style.grey500)),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormatter.format(cost.cost ?? 0),
                    style: TextStyle(
                      color: Style.blue800, // Matches your app theme
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Right: Estimation
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Estimation", style: TextStyle(color: Style.grey500)),
                  const SizedBox(height: 4),
                  Text(
                    formatEtd(cost.etd),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),

          // Close Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Style.blue800,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "Close", 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}