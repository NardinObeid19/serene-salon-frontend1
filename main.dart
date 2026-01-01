import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppointmentPage(),
    );
  }
}

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final String apiUrl = "http://localhost:3000/api/reservations";

  List appointments = [];

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    final res = await http.get(Uri.parse(apiUrl));
    if (res.statusCode == 200) {
      setState(() {
        appointments = jsonDecode(res.body);
      });
    }
  }

  Future<void> addAppointment() async {
    final res = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameController.text,
        "date": dateController.text,
        "goal": goalController.text,
      }),
    );

    print(res.statusCode);
    print(res.body);

    fetchAppointments();
    nameController.clear();
    dateController.clear();
    goalController.clear();
  }

  Future<void> updateAppointment() async {
    if (idController.text.isEmpty) return;

    await http.put(
      Uri.parse("$apiUrl/${idController.text}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameController.text,
        "date": dateController.text,
        "goal": goalController.text,
      }),
    );

    fetchAppointments();
  }

  Future<void> deleteAppointment() async {
    if (idController.text.isEmpty) return;

    await http.delete(Uri.parse("$apiUrl/${idController.text}"));

    fetchAppointments();
  }

  Widget inputField(
    IconData icon,
    TextEditingController controller,
    String hint,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            icon: Icon(icon, color: Colors.pink),
            hintText: hint,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget actionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
        
            Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6F9F), Color(0xFFFF4F8B)],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              child: const Center(
                child: Text(
                  "Serene Salon ✨",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  child: Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.pinkAccent.withOpacity(0.25),
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: AspectRatio(
        aspectRatio: 25/ 9, 
        child: Image.asset(
          'assets/images/salon2.jpg',
          fit: BoxFit.cover,
        ),
      ),
    ),
  ), 
),


            const SizedBox(height: 24), 

            const SizedBox(height: 20),

           
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  actionButton(
                    "Add",
                    Icons.favorite,
                    Colors.pink,
                    addAppointment,
                  ),
                  const SizedBox(width: 10),
                  actionButton(
                    "Update",
                    Icons.edit,
                    Colors.purple,
                    updateAppointment,
                  ),
                  const SizedBox(width: 10),
                  actionButton(
                    "Delete",
                    Icons.delete,
                    Colors.redAccent,
                    deleteAppointment,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

          
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      inputField(Icons.badge, idController, "ID"),
                      const SizedBox(width: 10),
                      inputField(Icons.person, nameController, "Name"),
                    ],
                  ),
                  Row(
                    children: [
                      inputField(Icons.calendar_today, dateController, "Date"),
                      const SizedBox(width: 10),
                      inputField(Icons.spa, goalController, "Service"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appointments.length,
                itemBuilder: (context, i) {
                  final a = appointments[i];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          const Icon(Icons.spa, color: Colors.pink),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  a["name"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("✨ ${a["goal"]}\n📅 ${a["date"]}"),
                              ],
                            ),
                          ),
                          Text(
                            "#${a["id"]}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
