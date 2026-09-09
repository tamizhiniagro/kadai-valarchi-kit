import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const KadaiValarchiApp());
}

class KadaiValarchiApp extends StatelessWidget {
  const KadaiValarchiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kadai Valarchi Kit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String businessName = 'என் கடை';
  double sales = 0;
  double expenses = 0;

  @override
  void initState() {
    super.initState();
    _loadBusiness();
  }

  Future<void> _loadBusiness() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      businessName = prefs.getString('business_name') ?? 'என் கடை';
    });
  }

  Future<void> _editBusiness() async {
    final controller = TextEditingController(text: businessName);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Business பெயர்'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'உங்கள் கடை / business பெயர்',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final value = controller.text.trim();
              final name = value.isEmpty ? 'என் கடை' : value;
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('business_name', name);
              setState(() => businessName = name);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _calculator() async {
    final salesController =
        TextEditingController(text: sales == 0 ? '' : sales.toStringAsFixed(0));
    final expenseController = TextEditingController(
        text: expenses == 0 ? '' : expenses.toStringAsFixed(0));

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily Profit Calculator'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: salesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Sales ₹',
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: expenseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Expenses ₹',
                prefixIcon: Icon(Icons.money_off),
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              setState(() {
                sales = double.tryParse(salesController.text) ?? 0;
                expenses = double.tryParse(expenseController.text) ?? 0;
              });
              Navigator.pop(context);
            },
            child: const Text('Calculate'),
          ),
        ],
      ),
    );
  }

  void _showInfo(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _feature(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 34),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profit = sales - expenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kadai Valarchi Kit'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.storefront, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          businessName,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        const Text('உங்கள் business-ஐ வளர்க்கும் tools'),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _editBusiness,
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.05,
            children: [
              _feature(
                Icons.campaign,
                'Marketing Posters',
                'Offer designs',
                () => _showInfo(
                  'Marketing Posters',
                  '20+ ready-made business poster templates இங்கே சேர்க்கலாம்.',
                ),
              ),
              _feature(
                Icons.chat,
                'WhatsApp Messages',
                'Ready messages',
                () => _showInfo(
                  'WhatsApp Messages',
                  'Customers-க்கு அனுப்ப ready-made Tamil marketing messages.',
                ),
              ),
              _feature(
                Icons.people,
                'Customer List',
                'Customer follow-up',
                () => _showInfo(
                  'Customer List',
                  'Customer பெயர், phone மற்றும் follow-up details சேமிக்கலாம்.',
                ),
              ),
              _feature(
                Icons.calculate,
                'Profit Calculator',
                'Sales - expense',
                _calculator,
              ),
              _feature(
                Icons.card_giftcard,
                'Festival Offers',
                'Season promotions',
                () => _showInfo(
                  'Festival Offers',
                  'Pongal, Tamil New Year, Deepavali போன்ற promotion packs.',
                ),
              ),
              _feature(
                Icons.qr_code_2,
                'QR Poster',
                'Payment poster',
                () => _showInfo(
                  'QR Poster',
                  'உங்கள் UPI/payment QR-ஐ business poster-ல் சேர்க்கலாம்.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Card(
            child: ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('Today Profit'),
              subtitle: Text(
                'Sales ₹${sales.toStringAsFixed(0)}  −  Expenses ₹${expenses.toStringAsFixed(0)}  =  ₹${profit.toStringAsFixed(0)}',
              ),
              trailing: IconButton(
                onPressed: _calculator,
                icon: const Icon(Icons.edit),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text('Pro Version — ₹299'),
              subtitle: const Text(
                'More templates, tools & business features',
              ),
              trailing: FilledButton(
                onPressed: () => _showInfo(
                  'Pro Version',
                  'Payment gateway integration அடுத்த production stage-ல் சேர்க்கப்படும்.',
                ),
                child: const Text('View'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
