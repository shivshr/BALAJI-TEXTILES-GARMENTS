import 'dart:async';
import 'package:balaji_textile_and_garments/core/constants/app_colors.dart';
import 'package:balaji_textile_and_garments/core/constants/app_routes.dart';
import 'package:balaji_textile_and_garments/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerifyScreen extends ConsumerStatefulWidget {
  final String phone;
  final bool isAdmin;

  const OtpVerifyScreen({
    required this.phone,
    this.isAdmin = false,
    super.key,
  });

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  final _otpController = TextEditingController();
  bool _loading = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendTimer = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        t.cancel();
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter 6-digit OTP'), backgroundColor: AppColors.error),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(authServiceProvider).verifyOtp(_otpController.text);

      if (mounted) {
        if (widget.isAdmin || widget.phone == '6261668801') {
          // Save admin session
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_admin', true);
          await prefs.setString('admin_phone', widget.phone);
          if (mounted) context.go(AppRoutes.adminDashboard);
        } else {
          if (mounted) context.go(AppRoutes.home);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _resendOtp() async {
    await ref.read(authServiceProvider).sendOtp(
      phoneNumber: widget.phone,
      onCodeSent: (_) {
        if (mounted) _startTimer();
      },
      onError: (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e)));
        }
      },
      onAutoVerified: () {
        if (mounted) {
          context.go(
            widget.isAdmin ? AppRoutes.adminDashboard : AppRoutes.home,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAdmin ? 'Admin Verification' : 'Verify OTP'),
        centerTitle: true, // Center the title
      ),
      body: SafeArea(
        child: Center( // Center the content vertically and horizontally
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Center align content
                children: [
                  const SizedBox(height: 20),
                  Text(
                    widget.isAdmin ? 'Admin Verification Code' : 'Enter OTP',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center, // Center align text
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'OTP sent to ${widget.phone}',
                    style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
                    textAlign: TextAlign.center, // Center align text
                  ),
                  if (widget.isAdmin) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F6C5C).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.admin_panel_settings, color: Color(0xFF0F6C5C), size: 16),
                          SizedBox(width: 6),
                          Text('Admin Access', style: TextStyle(color: Color(0xFF0F6C5C), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  Pinput(
                    controller: _otpController,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyDecorationWith(
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    onCompleted: (_) => _verifyOtp(),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _loading ? null : _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50), // Full-width button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Verify OTP'),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: _resendTimer > 0
                        ? Text(
                            'Resend OTP in ${_resendTimer}s',
                            style: const TextStyle(color: AppColors.textSecondary),
                          )
                        : TextButton(
                            onPressed: _resendOtp,
                            child: const Text(
                              'Resend OTP',
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}