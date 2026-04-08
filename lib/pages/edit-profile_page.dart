import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/user.dart';
import '../models/user_addresses.dart';
import '../session/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _usernameController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _countryController = TextEditingController();

  User? _user;
  File? _pickedImage;
  bool _removePicture = false;
  bool _isSaving = false;
  bool _isAddingAddress = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AuthService().getUserData();
    if (user != null) {
      _usernameController.text = user.username;
      setState(() => _user = user);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
        _removePicture = false;
      });
    }
  }

  void _clearImage() {
    setState(() {
      _pickedImage = null;
      _removePicture = true;
    });
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    final token = await AuthService().getToken();
    final uri = Uri.parse('${AuthService.baseUrl}/user');
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token';

    if (_usernameController.text.trim().isNotEmpty) {
      request.fields['username'] = _usernameController.text.trim();
    }

    if (_pickedImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'picture',
        _pickedImage!.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    } else if (_removePicture) {
      request.fields['remove_picture'] = 'true';
    }

    final response = await request.send();
    if (response.statusCode == 200) {
      await AuthService().updateUserData();
      await _loadUser();
      setState(() {
        _pickedImage = null;
        _removePicture = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated!')),
        );
      }
    }
    setState(() => _isSaving = false);
  }

  Future<void> _addAddress() async {
    if (_streetController.text.isEmpty ||
        _numberController.text.isEmpty ||
        _cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Street, number and city are required.')),
      );
      return;
    }

    setState(() => _isAddingAddress = true);
    final token = await AuthService().getToken();

    final response = await http.post(
      Uri.parse('${AuthService.baseUrl}/user/addresses'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: '{"street":"${_streetController.text}","number":"${_numberController.text}","neighborhood":"${_neighborhoodController.text}","city":"${_cityController.text}","state":"${_stateController.text}","zip_code":"${_zipCodeController.text}","country":"${_countryController.text}"}',
    );

    if (response.statusCode == 201) {
      await AuthService().updateUserData();
      await _loadUser();
      _streetController.clear();
      _numberController.clear();
      _neighborhoodController.clear();
      _cityController.clear();
      _stateController.clear();
      _zipCodeController.clear();
      _countryController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address added!')),
        );
      }
    }
    setState(() => _isAddingAddress = false);
  }

  Future<void> _setMainAddress(int addressId) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse('${AuthService.baseUrl}/user/main-address/$addressId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      await AuthService().updateUserData();
      await _loadUser();
    }
  }

  Future<void> _deleteAddress(int addressId) async {
    final token = await AuthService().getToken();
    final response = await http.delete(
      Uri.parse('${AuthService.baseUrl}/user/addresses/$addressId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      await AuthService().updateUserData();
      await _loadUser();
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  ImageProvider _resolveAvatar(Uint8List? currentPicture) {
    if (_pickedImage != null) return FileImage(_pickedImage!);
    if (!_removePicture && currentPicture != null) return MemoryImage(currentPicture);
    return const AssetImage("assets/profile_frame.png");
  }

  @override
  Widget build(BuildContext context) {
    final Uint8List? currentPicture = _user?.picture;
    final bool hasPicture = _pickedImage != null || (!_removePicture && currentPicture != null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Profile', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _resolveAvatar(currentPicture),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ),
                      if (hasPicture)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _clearImage,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              child: const Icon(Icons.close, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSaving
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Save Profile', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              ),
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            const Text('Add Address', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(flex: 3, child: _buildTextField(_streetController, 'Street', required: true)),
                const SizedBox(width: 10),
                Expanded(flex: 1, child: _buildTextField(_numberController, 'No.', required: true)),
              ],
            ),
            _buildTextField(_neighborhoodController, 'Neighborhood'),
            Row(
              children: [
                Expanded(flex: 2, child: _buildTextField(_cityController, 'City', required: true)),
                const SizedBox(width: 10),
                Expanded(flex: 1, child: _buildTextField(_stateController, 'State')),
              ],
            ),
            Row(
              children: [
                Expanded(child: _buildTextField(_zipCodeController, 'ZIP Code')),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField(_countryController, 'Country')),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isAddingAddress ? null : _addAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isAddingAddress
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Add Address', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              ),
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            const Text('My Addresses', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (_user!.addresses.isEmpty)
              const Text('No addresses registered.', style: TextStyle(color: Colors.grey))
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _user!.addresses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final address = _user!.addresses[index];
                  final isMain = address.id == _user!.mainAddressId;
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isMain ? Colors.black : Colors.grey[100],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${address.street}, ${address.number}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: isMain ? Colors.white : Colors.black,
                                ),
                              ),
                              if (address.neighborhood != null)
                                Text(address.neighborhood!, style: TextStyle(color: isMain ? Colors.white70 : Colors.grey)),
                              Text(
                                '${address.city}${address.state != null ? ', ${address.state}' : ''}',
                                style: TextStyle(color: isMain ? Colors.white70 : Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        if (isMain)
                          const Icon(Icons.home, color: Colors.white)
                        else
                          TextButton(
                            onPressed: () => _setMainAddress(address.id),
                            child: const Text('Set main', style: TextStyle(color: Colors.black)),
                          ),
                        IconButton(
                          onPressed: () => _deleteAddress(address.id),
                          icon: Icon(Icons.delete_outline, color: isMain ? Colors.white54 : Colors.red),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}