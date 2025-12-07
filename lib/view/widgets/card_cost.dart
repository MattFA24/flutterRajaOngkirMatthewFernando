part of 'widgets.dart';

class CardCost extends StatefulWidget {
  final Costs cost;
  const CardCost(this.cost, {super.key});

  @override
  State<CardCost> createState() => _CardCostState();
}

class _CardCostState extends State<CardCost> {
  String rupiahMoneyFormatter(int? value) {
    if (value == null) return "Rp0,00";
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  String formatEtd(String? etd) {
    if (etd == null || etd.isEmpty) return '-';
    return etd.replaceAll('day', 'hari').replaceAll('days', 'hari');
  }

  @override
  Widget build(BuildContext context) {
    Costs cost = widget.cost;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue[800]!),
      ),
      margin: const EdgeInsetsDirectional.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      color: Colors.white,
      child: ListTile(
        // This triggers the bottom sheet pop-up when the card is tapped
        onTap: () {
          showBottomSheetCost(context, cost);
        },
        title: Text(
          "${cost.name}: ${cost.service}",
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Biaya: ${rupiahMoneyFormatter(cost.cost)}",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Estimasi sampai: ${formatEtd(cost.etd)}",
              style: TextStyle(color: Colors.green[800]),
            ),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[50],
          child: Icon(Icons.local_shipping, color: Colors.blue[800]),
        ),
      ),
    );
  }
}
