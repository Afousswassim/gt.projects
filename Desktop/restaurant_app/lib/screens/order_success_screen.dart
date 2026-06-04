import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/helpers.dart';

class OrderSuccessScreen extends StatefulWidget {
  final Order order;

  const OrderSuccessScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmed'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildSuccessAnimation(),
              const SizedBox(height: 40),
              _buildOrderDetails(),
              const SizedBox(height: 24),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    return ScaleTransition(
      scale: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
      ),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_circle,
          size: 60,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Order ID:', widget.order.id),
            _buildDetailRow('Customer Name:', widget.order.customerName),
            _buildDetailRow('Phone:', widget.order.phone),
            _buildDetailRow('Address:', widget.order.address),
            _buildDetailRow('Subtotal:', CurrencyFormatter.formatDH(widget.order.subtotal)),
            _buildDetailRow('Delivery Fee:', CurrencyFormatter.formatDH(widget.order.deliveryFee)),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              padding: const EdgeInsets.only(top: 12),
              child: _buildDetailRow(
                'Total Amount:',
                CurrencyFormatter.formatDH(widget.order.totalAmount),
                isBold: true,
                isHighlighted: true,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Status:', widget.order.statusDisplay),
            _buildDetailRow('Payment Method:', widget.order.paymentMethod == 'cash' ? 'Cash on Delivery' : 'Card Payment'),
            _buildDetailRow('Estimated Delivery:', '${widget.order.estimatedDeliveryTime} minutes'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isBold ? 14 : 13,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isBold ? 14 : 13,
                color: isHighlighted ? Colors.deepOrange : null,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Back to Home',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            // Can implement order tracking here
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Track order feature coming soon')),
            );
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: Colors.deepOrange),
          ),
          child: const Text(
            'Track Order',
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
