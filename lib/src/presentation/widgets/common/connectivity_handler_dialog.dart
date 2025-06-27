import 'package:flutter/material.dart';

import '../base_dialog_layout.dart';

class ConnectivityHandlerDialog extends StatelessWidget {
  const ConnectivityHandlerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseDialogLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 50),
          SizedBox(height: 16),
          Text('Không có kết nối mạng', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text('Vui lòng kiểm tra lại kết nối mạng', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
