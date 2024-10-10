import 'dart:io';

import 'package:file_picker/file_picker.dart';

/// A service class responsible for picking files of specific types using FilePicker.
class FilePickerService {
  /// Constructs a new instance of [FilePickerService].
  FilePickerService();

  /// Instance of the FilePicker platform interface used for picking files.
  final _filePicker = FilePicker.platform;

  /// Picks a file of the specified [fileType].
  ///
  /// This method is used internally to pick files of different types.
  ///
  /// Parameters:
  ///   - [fileType] : The type of file to pick (image, video, or audio).
  ///
  /// Returns a [File] representing the picked file.
  /// If no file is picked, returns null.
  ///
  /// Throws an error if there's an issue during the file picking process.
  Future<File?> _pickFile({
    required FileType fileType,
    List<String>? allowedExtensions,
  }) async {
    try {
      // Pick file of specified type
      FilePickerResult? result = await _filePicker.pickFiles(
        type: fileType,
        allowedExtensions: allowedExtensions,
      );
      // Return the first file if available
      final platformFile = result?.files.first;
      if (platformFile == null) return null;
      final file = File(platformFile.path!);
      return file;
    } catch (e) {
      // Rethrow any caught exceptions
      rethrow;
    }
  }

  /// Allows the user to pick an image file and returns the selected file.
  ///
  /// Returns a [File] representing the picked image file.
  /// If no file is picked, returns null.
  ///
  /// Throws an error if there's an issue during the file picking process.
  Future<File?> pickImage() async {
    try {
      // Call internal method to pick image file
      return await _pickFile(fileType: FileType.image);
    } catch (e) {
      // Rethrow any caught exceptions
      rethrow;
    }
  }

  /// Allows the user to pick a video file and returns the selected file.
  ///
  /// Returns a [File] representing the picked video file.
  /// If no file is picked, returns null.
  ///
  /// Throws an error if there's an issue during the file picking process.
  Future<File?> pickVideo() async {
    try {
      // Call internal method to pick video file
      return await _pickFile(fileType: FileType.video);
    } catch (e) {
      // Rethrow any caught exceptions
      rethrow;
    }
  }

  /// Allows the user to pick an audio file and returns the selected file.
  ///
  /// Returns a [File] representing the picked audio file.
  /// If no file is picked, returns null.
  ///
  /// Throws an error if there's an issue during the file picking process.
  Future<File?> pickAudio() async {
    try {
      // Call internal method to pick audio file
      return await _pickFile(fileType: FileType.audio);
    } catch (e) {
      // Rethrow any caught exceptions
      rethrow;
    }
  }

  /// Allows the user to pick any file and returns the selected file.
  ///
  /// Returns a [File] representing the picked file.
  /// If no file is picked, returns null.
  ///
  /// Throws an error if there's an issue during the file picking process.
  Future<File?> pickFile() async {
    try {
      // Call internal method to pick file
      return await _pickFile(
        fileType: FileType.custom,
        allowedExtensions: ['pdf'],
      );
    } catch (e) {
      // Rethrow any caught exceptions
      rethrow;
    }
  }
}
