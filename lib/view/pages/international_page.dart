part of 'pages.dart';

class InternationalPage extends StatefulWidget {
  const InternationalPage({super.key});

  @override
  State<InternationalPage> createState() => _InternationalPageState();
}

class _InternationalPageState extends State<InternationalPage> {
  late HomeViewModel homeViewModel;
  final weightController = TextEditingController();

  final List<String> courierOptions = ["jne", "pos", "tiki", "ray"]; // Added 'ray'
  String selectedCourier = "jne";

  int? selectedProvinceOriginId;
  int? selectedCityOriginId;
  String? selectedCountryDestinationId; // Store the ID of selected country

  @override
  void initState() {
    super.initState();
    homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    // Only fetch provinces for Origin (Indonesia)
    if (homeViewModel.provinceList.status == Status.notStarted) {
      homeViewModel.getProvinceList();
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Input Card
                Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // 1. Courier & Weight
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedCourier,
                                items: courierOptions.map((c) => DropdownMenuItem(value: c, child: Text(c.toUpperCase()))).toList(),
                                onChanged: (v) => setState(() => selectedCourier = v ?? "jne"),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: weightController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: 'Berat (gr)'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // 2. Origin Section (Indonesia)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Origin (Indonesia)", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          children: [
                            // Province
                            Expanded(
                              child: Consumer<HomeViewModel>(
                                builder: (context, vm, _) {
                                  if (vm.provinceList.status == Status.loading) {
                                    return const SizedBox(height: 40, child: Center(child: CircularProgressIndicator(color: Colors.black)));
                                  }
                                  final provinces = vm.provinceList.data ?? [];
                                  return DropdownButton<int>(
                                    isExpanded: true,
                                    value: selectedProvinceOriginId,
                                    hint: const Text('Provinsi'),
                                    items: provinces.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name ?? ''))).toList(),
                                    onChanged: (newId) {
                                      setState(() {
                                        selectedProvinceOriginId = newId;
                                        selectedCityOriginId = null;
                                      });
                                      if (newId != null) vm.getCityOriginList(newId);
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            // City
                            Expanded(
                              child: Consumer<HomeViewModel>(
                                builder: (context, vm, _) {
                                  if (vm.cityOriginList.status == Status.loading) {
                                    return const SizedBox(height: 40, child: Center(child: CircularProgressIndicator(color: Colors.black)));
                                  }
                                  final cities = vm.cityOriginList.data ?? [];
                                  final validIds = cities.map((c) => c.id).toSet();
                                  final validValue = validIds.contains(selectedCityOriginId) ? selectedCityOriginId : null;

                                  return DropdownButton<int>(
                                    isExpanded: true,
                                    value: validValue,
                                    hint: const Text('Kota'),
                                    items: cities.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name ?? ''))).toList(),
                                    onChanged: (newId) => setState(() => selectedCityOriginId = newId),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // 3. Destination Section (International)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Destination (International)", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8),
                        
                        // === AUTOCOMPLETE SEARCH BAR ===
                        // This replaces the DropdownButton with a Searchable Text Field
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Autocomplete<Country>(
                              optionsBuilder: (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<Country>.empty();
                                }
                                // Calls the search function in ViewModel
                                return homeViewModel.searchDestination(textEditingValue.text);
                              },
                              onSelected: (Country selection) {
                                setState(() {
                                  selectedCountryDestinationId = selection.id;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Negara dipilih: ${selection.name}')),
                                );
                              },
                              displayStringForOption: (Country option) => option.name ?? '',
                              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  onEditingComplete: onEditingComplete,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Cari Negara Tujuan',
                                    hintText: 'Ketik nama negara (min. 3 huruf)',
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                );
                              },
                            );
                          }
                        ),
                        const SizedBox(height: 24),

                        // 4. Calculate Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedCityOriginId != null && 
                                  selectedCountryDestinationId != null && 
                                  weightController.text.isNotEmpty) {
                                
                                final weight = int.tryParse(weightController.text) ?? 0;
                                if (weight <= 0) return;

                                homeViewModel.checkInternationalShipmentCost(
                                  selectedCityOriginId.toString(),
                                  selectedCountryDestinationId!,
                                  weight,
                                  selectedCourier,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Lengkapi semua data'), backgroundColor: Colors.redAccent),
                                );
                              }
                            },
                            child: const Text("Hitung Ongkir"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Result Card (Reusing existing logic)
                Card(
                  color: Colors.blue[50],
                  elevation: 2,
                  child: Consumer<HomeViewModel>(
                    builder: (context, vm, _) {
                      switch (vm.costList.status) {
                        case Status.loading:
                          return const Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator(color: Colors.black)));
                        case Status.error:
                          return Padding(padding: const EdgeInsets.all(16.0), child: Center(child: Text(vm.costList.message ?? 'Error', style: const TextStyle(color: Colors.red))));
                        case Status.completed:
                          if (vm.costList.data == null || vm.costList.data!.isEmpty) {
                            return const Padding(padding: EdgeInsets.all(16.0), child: Center(child: Text("Tidak ada layanan tersedia.")));
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: vm.costList.data?.length ?? 0,
                            itemBuilder: (context, index) => CardCost(vm.costList.data!.elementAt(index)),
                          );
                        default:
                          return const Padding(padding: EdgeInsets.all(16.0), child: Center(child: Text("Pilih negara dan klik Hitung Ongkir.", style: TextStyle(color: Colors.black))));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // Loading Overlay
          Consumer<HomeViewModel>(
            builder: (context, vm, _) {
              if (vm.isLoading) {
                return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}