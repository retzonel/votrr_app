import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../data/face_detection_service.dart';

class FaceVerificationPage extends StatefulWidget {
  const FaceVerificationPage({super.key});

  @override
  State<FaceVerificationPage> createState() => _FaceVerificationPageState();
}

class _FaceVerificationPageState extends State<FaceVerificationPage>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  final FaceDetectionService _faceService = FaceDetectionService();

  bool _isInitialising = true;
  bool _isScanning = false;
  String _statusMessage = 'Initialising camera...';
  String? _errorMessage;
  int _countdown = 3;
  bool _hasPopped = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween(begin: 0.95, end: 1.05).animate(_pulseController);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();

      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (!mounted) return;
      setState(() {
        _isInitialising = false;
        _statusMessage = 'Position your face in the frame';
      });

      _startCountdown();
    } catch (e) {
      setState(() {
        _isInitialising = false;
        _errorMessage = 'Camera could not be initialised.';
      });
    }
  }

  Future<void> _startCountdown() async {
    for (int i = 3; i > 0; i--) {
      if (!mounted) return;
      setState(() {
        _countdown = i;
        _statusMessage = 'Hold still — scanning in $i...';
      });
      await Future.delayed(const Duration(seconds: 1));
    }
    if (mounted) _scan();
  }

  Future<void> _scan() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isScanning = true;
      _statusMessage = 'Scanning...';
      _errorMessage = null;
    });

    final result = await _faceService.verifyFromCamera(_cameraController!);

    if (!mounted) return;

    switch (result) {
      case FaceVerificationResult.success:
        setState(() => _statusMessage = 'Face verified ✓');
        await Future.delayed(const Duration(milliseconds: 600));
        if (mounted) _safePop(true);

      case FaceVerificationResult.noFace:
        _setError('No face detected. Please look directly at the camera.');

      case FaceVerificationResult.tooFar:
        _setError('Move closer to the camera.');

      case FaceVerificationResult.notStraight:
        _setError('Please hold the phone straight and look forward.');

      case FaceVerificationResult.cameraError:
        _setError('Camera error. Please try again.');
    }
  }

  void _setError(String message) {
    setState(() {
      _isScanning = false;
      _errorMessage = message;
      _statusMessage = 'Verification failed';
    });
  }

  Future<void> _retry() async {
    setState(() {
      _errorMessage = null;
      _countdown = 3;
    });
    await _startCountdown();
  }

  void _safePop(bool result) {
    if (_hasPopped || !mounted) return;
    _hasPopped = true;
    Navigator.of(context).pop(result);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _cameraController?.dispose();
    _faceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildCameraArea()),
            _buildBottomPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => _safePop(false),
          ),
          const Expanded(
            child: Text(
              'Face Verification',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildCameraArea() {
    if (_isInitialising) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryGreen),
      );
    }

    if (_errorMessage != null && _cameraController == null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        if (_cameraController != null && _cameraController!.value.isInitialized)
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),
        _buildFaceOverlay(),
      ],
    );
  }

  Widget _buildFaceOverlay() {
    final color = _errorMessage != null
        ? Colors.red
        : _isScanning
            ? AppTheme.primaryGreen
            : Colors.white;

    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        width: 240,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(120),
          border: Border.all(color: color, width: 3),
        ),
        child: _isScanning
            ? Center(
                child: CircularProgressIndicator(
                  color: color,
                  strokeWidth: 2,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Text(
            _statusMessage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.white60, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: _retry,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Try Again',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
