import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  String? selectedDoctorId;
  String? selectedDoctorName;
  DateTime? selectedDate;
  bool loading = false;

  // PICK DATE
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  //  BOOK APPOINTMENT
  Future<void> bookAppointment() async {
    if (selectedDoctorId == null || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select doctor and date")),
      );
      return;
    }

    setState(() => loading = true);

    final user = FirebaseAuth.instance.currentUser!;

    //  FETCH PATIENT NAME
    final patientDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final patientName = patientDoc.data()?['name'] ?? 'Patient';

    //  CREATE APPOINTMENT
    await FirebaseFirestore.instance.collection('appointments').add({
      'patientId': user.uid,
      'patientName': patientName,
      'doctorId': selectedDoctorId,
      'doctorName': selectedDoctorName ?? 'Doctor',
      'date': Timestamp.fromDate(selectedDate!),
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Appointment booked successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Appointment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 👨‍⚕️ DOCTOR DROPDOWN
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'doctor')
                  .where('approved', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text("No doctors available");
                }

                final docs = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Select Doctor",
                    border: OutlineInputBorder(),
                  ),
                  items: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return DropdownMenuItem<String>(
                      value: doc.id,
                      child: Text(data['name'] ?? 'Doctor'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final doc = docs.firstWhere(
                      (element) => element.id == value,
                    );
                    setState(() {
                      selectedDoctorId = value;
                      selectedDoctorName =
                          (doc.data() as Map<String, dynamic>)['name'];
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            //  DATE PICKER
            ElevatedButton(
              onPressed: pickDate,
              child: Text(
                selectedDate == null
                    ? "Select Date"
                    : selectedDate!.toLocal().toString().split(' ')[0],
              ),
            ),

            const SizedBox(height: 30),

            //  CONFIRM BUTTON
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: bookAppointment,
                    child: const Text("Confirm Appointment"),
                  ),
          ],
        ),
      ),
    );
  }
}
