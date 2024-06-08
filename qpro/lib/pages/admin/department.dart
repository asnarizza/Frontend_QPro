// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import '../../repository/api_constant.dart';
//
// class AddDepartmentPage extends StatefulWidget {
//   @override
//   _AddDepartmentPageState createState() => _AddDepartmentPageState();
// }
//
// class _AddDepartmentPageState extends State<AddDepartmentPage> {
//   TextEditingController departmentNameController = TextEditingController();
//   bool _isLoading = false; // Add loading state
//
//   Future<void> _sendAddDepartmentRequest(String name) async {
//     final url = Uri.parse(APIConstant.DepartmentURL);
//
//     setState(() {
//       _isLoading = true; // Set loading state to true
//     });
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'name': name,
//         }),
//       );
//
//       setState(() {
//         _isLoading = false; // Set loading state to false after request completes
//       });
//
//       if (response.statusCode == 201) {
//         final responseBody = jsonDecode(response.body);
//         _showSuccessDialog(responseBody['department']['name'], responseBody['qr_code']);
//       } else {
//         _showErrorDialog('Failed to add department. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false; // Set loading state to false on error
//       });
//       _showErrorDialog('Network error occurred: $e');
//     }
//   }
//
//   Future<void> _saveQrCodeToGallery(String qrCodeUrl) async {
//     try {
//       // Get the image bytes
//       var response = await http.get(Uri.parse(qrCodeUrl));
//       var bytes = response.bodyBytes;
//
//       // Save the image to the gallery
//       await ImageGallerySaver.saveImage(bytes);
//
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('QR code saved to gallery')),
//       );
//     } catch (e) {
//       // Show error message if any
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to save QR code: $e')),
//       );
//     }
//   }
//
//   void _showSuccessDialog(String departmentName, String qrCodeUrl) {
//     _saveQrCodeToGallery(qrCodeUrl); // Automatically save QR code to gallery
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Success'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Department added: $departmentName'),
//               SizedBox(height: 10),
//               Image.network(qrCodeUrl),
//             ],
//           ),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 Navigator.of(context).pop(); // Close the add department page
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Department'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.teal.shade100, Colors.teal.shade500],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(16.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 10,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Add New Department',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.teal.shade900,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         TextField(
//                           controller: departmentNameController,
//                           decoration: InputDecoration(
//                             hintText: 'Enter department name',
//                             labelText: 'Department Name',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         _isLoading
//                             ? Center(child: CircularProgressIndicator()) // Show CircularProgressIndicator when loading
//                             : _buildButton(
//                           onPressed: () async {
//                             String departmentName = departmentNameController.text;
//                             if (departmentName.isNotEmpty) {
//                               await _sendAddDepartmentRequest(departmentName);
//                             } else {
//                               _showErrorDialog('Please enter a department name');
//                             }
//                           },
//                           label: 'Add Department',
//                           icon: Icons.add,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildButton({
//     required VoidCallback onPressed,
//     required String label,
//     required IconData icon,
//   }) {
//     return Container(
//       width: double.infinity,
//       height: 60,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15.0),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.teal.withOpacity(0.3),
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: ElevatedButton.icon(
//         onPressed: onPressed,
//         icon: Icon(icon, size: 30),
//         label: Text(
//           label,
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.teal.shade900,
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           foregroundColor: Colors.teal.shade900,
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           elevation: 0,
//         ),
//       ),
//     );
//   }
// }
