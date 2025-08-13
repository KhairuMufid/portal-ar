import 'package:flutter/material.dart';
// import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityFaceFilterPage extends StatefulWidget {
  final String contentId;

  const UnityFaceFilterPage({super.key, required this.contentId});

  @override
  State<UnityFaceFilterPage> createState() => _UnityFaceFilterPageState();
}

class _UnityFaceFilterPageState extends State<UnityFaceFilterPage> {
  bool _isUnityLoaded = false;

  @override
  void initState() {
    super.initState();
    // Simulate Unity loading
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isUnityLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Unity Widget Placeholder
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF6A5ACD).withOpacity(0.8),
                  const Color(0xFF87CEEB).withOpacity(0.6),
                  Colors.black,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    _isUnityLoaded ? 'Unity AR Ready' : 'Loading Unity...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tap to simulate AR experience',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Content: ${widget.contentId}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (!_isUnityLoaded)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Simulated Unity controls
          if (_isUnityLoaded)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 20,
              right: 20,
              child: Column(
                children: [
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white.withOpacity(0.8),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Camera switched (simulated)')),
                      );
                    },
                    child:
                        const Icon(Icons.flip_camera_ios, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white.withOpacity(0.8),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Screenshot taken (simulated)')),
                      );
                    },
                    child: const Icon(Icons.camera, color: Colors.black),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
