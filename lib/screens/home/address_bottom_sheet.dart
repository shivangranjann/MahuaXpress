import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/user_address_model.dart';
import '../../providers/app_provider.dart';

class AddressBottomSheet extends StatefulWidget {
  const AddressBottomSheet({super.key});

  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  bool _showAddForm = false;
  final _flatController = TextEditingController();
  final _buildingController = TextEditingController();
  final _addressLineController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController(text: 'Patna, Bihar 800001');
  String _selectedLabel = 'Home';

  @override
  void dispose() {
    _flatController.dispose();
    _buildingController.dispose();
    _addressLineController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _saveNewAddress() {
    if (_flatController.text.trim().isEmpty || _buildingController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter flat/house and building details')),
      );
      return;
    }

    final newAddr = UserAddressModel(
      id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
      label: _selectedLabel,
      flatNumber: _flatController.text.trim(),
      buildingName: _buildingController.text.trim(),
      addressLine: _addressLineController.text.trim().isEmpty
          ? 'Near Main Road'
          : _addressLineController.text.trim(),
      area: _areaController.text.trim().isEmpty ? 'Central Sector' : _areaController.text.trim(),
      city: _cityController.text.trim(),
      isDefault: false,
    );

    final app = Provider.of<AppProvider>(context, listen: false);
    app.addAddress(newAddr);
    app.selectAddress(newAddr);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final addresses = app.addresses;
    final selected = app.selectedAddress;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Choose Delivery Location',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (!_showAddForm) ...[
            // List of saved addresses
            ...addresses.map((addr) {
              final isChosen = selected?.id == addr.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isChosen ? AppColors.brandGreenLight : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isChosen ? AppColors.brandGreen : AppColors.border,
                    width: isChosen ? 1.5 : 1,
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    app.selectAddress(addr);
                    Navigator.pop(context);
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isChosen ? AppColors.brandGreen : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      addr.label.toLowerCase() == 'home'
                          ? Icons.home_rounded
                          : Icons.work_rounded,
                      color: isChosen ? Colors.white : AppColors.textSecondary,
                      size: 18,
                    ),
                  ),
                  title: Text(
                    addr.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isChosen ? AppColors.brandGreenDark : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    addr.fullDisplay,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  trailing: isChosen
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.brandGreen)
                      : null,
                ),
              );
            }),

            const SizedBox(height: 10),

            // Add New Address Button
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _showAddForm = true;
                });
              },
              icon: const Icon(Icons.add_location_alt_outlined, size: 18),
              label: const Text('Add New Address'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 46),
                side: const BorderSide(color: AppColors.brandGreen, width: 1.5),
              ),
            ),
          ] else ...[
            // Add Address Form
            const Text(
              'Add New Address',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            // Tag selector (Home, Work, Other)
            Row(
              children: ['Home', 'Work', 'Other'].map((label) {
                final isSelected = _selectedLabel == label;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    selectedColor: AppColors.brandGreenLight,
                    onSelected: (val) {
                      setState(() {
                        _selectedLabel = label;
                      });
                    },
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.brandGreenDark : AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _flatController,
              decoration: const InputDecoration(
                labelText: 'House / Flat / Floor No.',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _buildingController,
              decoration: const InputDecoration(
                labelText: 'Apartment / Building Name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _areaController,
              decoration: const InputDecoration(
                labelText: 'Street / Area / Landmark',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City & Pincode',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _showAddForm = false;
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveNewAddress,
                    child: const Text('Save Address'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
