import '../../../imports.dart';

class MyHouse extends StatefulWidget {
  const MyHouse({super.key});

  @override
  State<MyHouse> createState() => _MyHouseState();
}

class _MyHouseState extends State<MyHouse> {
  final List<Map<String, dynamic>> houseData = [
    {
      "society": "Omax City",
      "units": ["A-201", "B-305"],
    },
    {
      "society": "NPRS",
      "units": ["A-201", "B-305"],
    },
  ];

  Widget houseCard(BuildContext context, String society, List<String> units) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.apartment, color: Colors.blue, size: 30),
              const SizedBox(width: 10),
              Text(
                society,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 1),
          ...units.map((unit) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(unit),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Handle unit navigation
            },
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: false,
        isFixedDeviceHeight: true,
        isListScrollingNeed: true,
        appBarHeight: 56,
        appBar: const DetailsScreenAppBar(
          title: "Manage Houses",
        ),
        containChild: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: houseData.length,
          itemBuilder: (context, index) {
            return houseCard(
              context,
              houseData[index]['society'],
              houseData[index]['units'],
            );
          },
        ),

    );
  }
}

