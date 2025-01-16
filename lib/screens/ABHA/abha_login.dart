import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResponsiveABHALogin extends StatefulWidget {
  const ResponsiveABHALogin({Key? key}) : super(key: key);

  @override
  State<ResponsiveABHALogin> createState() => _ResponsiveABHALoginState();
}

class _ResponsiveABHALoginState extends State<ResponsiveABHALogin> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _mobileController = TextEditingController();
  final List<TextEditingController> _abhaControllers = List.generate(4, (_) => TextEditingController());
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _clearFields();
      }
    });
  }

  void _clearFields() {
    _mobileController.clear();
    _otpController.clear();
    for (var controller in _abhaControllers) {
      controller.clear();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mobileController.dispose();
    for (var controller in _abhaControllers) {
      controller.dispose();
    }
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title:  Text('Login To Your ABHA',
            style: TextStyle(
              fontSize: 18, // Adjust font size
              fontWeight: FontWeight.bold, // Make text bold
            )),
        backgroundColor: const Color(0xFF243B6D),
        foregroundColor: Colors.white,),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isSmallScreen ? 12 : 16),
              _buildTabs(isSmallScreen),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMobileNumberView(isSmallScreen),
                    _buildABHANumberView(isSmallScreen),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelStyle: TextStyle(
          fontSize: isSmallScreen ? 14 : 16,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Mobile Number'),
          Tab(text: 'ABHA Number'),
        ],
        labelColor: Colors.blue[700],
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blue[700],
      ),
    );
  }

  Widget _buildMobileNumberView(bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.only(top: isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mobile number*',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          _buildMobileInput(),
          SizedBox(height: isSmallScreen ? 16 : 20),
          _buildOTPInput(isSmallScreen),
          SizedBox(height: isSmallScreen ? 16 : 20),
          _buildNextButton(),
          const Spacer(),
          _buildBottomLinks(isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildABHANumberView(bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.only(top: isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter ABHA number*',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          _buildABHAInput(isSmallScreen),
          SizedBox(height: isSmallScreen ? 16 : 20),
          _buildOTPInput(isSmallScreen),
          SizedBox(height: isSmallScreen ? 16 : 20),
          _buildNextButton(),
          const Spacer(),
          _buildBottomLinks(isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildMobileInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey[300]!)),
            ),
            child: const Text(
              '+91',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                hintText: 'Enter mobile number',
                border: InputBorder.none,
                counterText: '',
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.green),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildABHAInput(bool isSmallScreen) {
    return Row(
      children: List.generate(4, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 2 : 4),
            child: TextFormField(
              controller: _abhaControllers[index],
              textAlign: TextAlign.center,
              maxLength: index == 0 ? 2 : 4,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                hintText: index == 0 ? '00' : '0000',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 8 : 12,
                  horizontal: isSmallScreen ? 4 : 8,
                ),
              ),
              onChanged: (value) {
                if (value.length == (index == 0 ? 2 : 4) && index < 3) {
                  FocusScope.of(context).nextFocus();
                }
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOTPInput(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter OTP*',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            hintText: 'Enter OTP',
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Next',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomLinks(bool isSmallScreen) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () {},
          child: Text(
            'Forgot your ABHA number?',
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: isSmallScreen ? 10 : 12,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Retrieve your Enrolment number',
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: isSmallScreen ? 10 : 12,
            ),
          ),
        ),
      ],
    );
  }
}