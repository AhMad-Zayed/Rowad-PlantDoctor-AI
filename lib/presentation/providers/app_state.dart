import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/plant_analysis_model.dart';
import '../../data/services/gemini_service.dart';
import '../../data/services/history_service.dart';

class AppState extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final HistoryService _historyService = HistoryService();

  String _apiKey = '';
  List<HistoryItem> _history = [];
  bool _isLoading = false;
  bool _isChatLoading = false;
  String? _errorMessage;
  PlantAnalysisModel? _currentAnalysis;
  String? _currentImagePath;
  final List<Content> _chatHistory = [];

  // Getters
  String get apiKey => _apiKey;
  List<HistoryItem> get history => _history;
  bool get isLoading => _isLoading;
  bool get isChatLoading => _isChatLoading;
  String? get errorMessage => _errorMessage;
  PlantAnalysisModel? get currentAnalysis => _currentAnalysis;
  String? get currentImagePath => _currentImagePath;
  List<Content> get chatHistory => _chatHistory;

  // Stats computed from history
  int get totalScans => _history.length;
  int get healthyCount => _history.where((item) => item.analysis.healthStatus.contains('سليم') || item.analysis.healthStatus.toLowerCase().contains('healthy')).length;
  int get sickCount => totalScans - healthyCount;

  /// Initializes the app state by loading API Key and history.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString('gemini_api_key') ?? '';
    await loadHistory();
  }

  /// Saves the Gemini API Key to SharedPreferences.
  Future<void> setApiKey(String key) async {
    _apiKey = key.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gemini_api_key', _apiKey);
    notifyListeners();
  }

  /// Refreshes the scan history from SharedPreferences.
  Future<void> loadHistory() async {
    _history = await _historyService.getHistory();
    notifyListeners();
  }

  /// Triggers plant analysis using the Gemini API.
  Future<void> analyzePlantImage(String imagePath) async {
    _isLoading = true;
    _currentImagePath = imagePath;
    _errorMessage = null;
    _currentAnalysis = null;
    notifyListeners();

    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('ملف الصورة غير موجود على القرص.');
      }

      final imageBytes = await file.readAsBytes();

      // Call Gemini for analysis
      final analysis = await _geminiService.analyzePlant(
        imageBytes: imageBytes,
        apiKey: _apiKey,
      );

      // Save to SharedPreferences local history
      await _historyService.saveScan(
        pickedImagePath: imagePath,
        analysis: analysis,
      );

      _currentAnalysis = analysis;
      await loadHistory(); // Refresh history list
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception:', '').trim();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sends a user message to the Gemini chatbot.
  Future<void> sendChatMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Append user message
    _chatHistory.add(Content.text(message));
    _isChatLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final responseText = await _geminiService.getChatResponse(
        chatHistory: _chatHistory,
        apiKey: _apiKey,
      );

      // Append model response
      _chatHistory.add(Content.model([TextPart(responseText)]));
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      // Remove last user message on failure to allow retry
      if (_chatHistory.isNotEmpty) {
        _chatHistory.removeLast();
      }
    } finally {
      _isChatLoading = false;
      notifyListeners();
    }
  }

  /// Clears the chat conversation history.
  void clearChat() {
    _chatHistory.clear();
    notifyListeners();
  }

  /// Deletes a single scan item.
  Future<void> deleteHistoryItem(String id) async {
    await _historyService.deleteScan(id);
    await loadHistory();
  }

  /// Clears the entire local scan history.
  Future<void> clearAllHistory() async {
    await _historyService.clearHistory();
    await loadHistory();
  }

  /// Clears active analysis data.
  void resetAnalysis() {
    _currentAnalysis = null;
    _currentImagePath = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
