import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';

class RideHistoryItem extends StatelessWidget {
  final String title;
  final String price;
  final String date;
  final String status;
  final Color statusColor;

  const RideHistoryItem({
    Key ? key,
    required this.title,
    required this.date,
    required this.price,
    required this.status,
    required this.statusColor
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset("assets/images/horse-2.jpg",
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover
              ), 
            ),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins', fontSize: 12.0 )),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2,),
                Text(date, style: const TextStyle(color: Colors.grey, fontFamily: 'Poppins', fontSize: 11.0 )),
                const SizedBox(height: 2,),
                Text(status,
                style: TextStyle(
                  color: statusColor, fontWeight: FontWeight.w400, fontFamily: 'Poppins', fontSize: 11.0 
                )
                ),
              ],
            ),
            trailing: Text(price,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: AppColors.primary)
            ),
          ),
        ),
      ),
    );
  }
}
