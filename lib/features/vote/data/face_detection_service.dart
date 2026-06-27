import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

enum FaceVerificationResult {
  success,
  noFace,
  tooFar,
  notStraight,
  cameraError,
}

class FaceDetectionService {
  FaceDetectionService();

  Future<FaceVerificationResult> verifyFromCamera(
      CameraController controller) async {
    final detector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
        enableClassification: false,
        enableTracking: false,
        minFaceSize: 0.25,
      ),
    );

    try {
      final image = await controller.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final faces = await detector.processImage(inputImage);

      if (faces.isEmpty) return FaceVerificationResult.noFace;

      final face = faces
          .reduce((a, b) => a.boundingBox.width > b.boundingBox.width ? a : b);

      if (face.boundingBox.width < 100) {
        return FaceVerificationResult.tooFar;
      }

      final yaw = face.headEulerAngleY ?? 0;
      final pitch = face.headEulerAngleX ?? 0;
      if (yaw.abs() > 30 || pitch.abs() > 30) {
        return FaceVerificationResult.notStraight;
      }

      return FaceVerificationResult.success;
    } catch (e) {
      return FaceVerificationResult.cameraError;
    } finally {
      await detector.close();
    }
  }

  void dispose() {}
}
