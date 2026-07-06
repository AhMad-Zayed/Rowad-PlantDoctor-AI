import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/plant_analysis_model.dart';

class GeminiService {
  /// Analyzes the plant image by calling the Gemini API and parsing its output into a PlantAnalysisModel.
  Future<PlantAnalysisModel> analyzePlant({
    required Uint8List imageBytes,
    required String apiKey,
  }) async {
    if (apiKey.trim().isEmpty) {
      throw Exception('يرجى ضبط مفتاح Gemini API Key في شاشة الإعدادات أولاً.');
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      final prompt = '''
أنت خبير عالمي في علم النباتات وتشخيص أمراض النبات وتنسيق الحدائق.
قم بتحليل الصورة المرفقة للنبات بدقة عالية باللغة العربية الفصحى حصراً وبشكل متكامل.
يجب أن ترجع ردك بصيغة JSON فقط. يجب أن يكون الرد عبارة عن كائن JSON صالح ومطابق تماماً للهيكل والأسماء التالية دون أي كود ماركداون (لا تستخدم ```json) ودون أي نص إضافي قبل أو بعد كائن الـ JSON:
{
  "plantName": "اسم النبتة الشائع باللغة العربية",
  "scientificName": "الاسم العلمي اللاتيني للنبتة",
  "family": "العائلة النباتية التي ينتمي إليها النبات",
  "origin": "الموطن الأصلي أو المنطقة الجغرافية الأصلية للنبتة",
  "countries": "الدول أو المناطق التي تشتهر بزراعتها أو تنتشر فيها حالياً",
  "environment": "البيئة المناسبة للنمو (مثال: معتدلة، استوائية، صحراوية، داخلية/خارجية)",
  "temperature": "درجة الحرارة المثالية للنمو بالدرجات المئوية (مثال: 18-25°م)",
  "humidity": "مستوى الرطوبة المناسب للتربة والجو المحيط (مثال: رطوبة عالية، معتدلة، جافة)",
  "soil": "نوع التربة المناسبة وخصائصها (مثال: تربة رملية جيدة التصريف، تربة طينية غنية بالمواد العضوية)",
  "sunlight": "كمية الإضاءة أو أشعة الشمس المطلوبة ومكان وضعها (مثال: ضوء شمس مباشر، ضوء شمس غير مباشر، ظل جزئي)",
  "wateringSchedule": "جدول الري وكمية المياه المطلوبة ومعدل مرات الري بالتفصيل (مثال: ري معتدل عند جفاف السطح العلوي للتربة بعمق 3 سم)",
  "fertilizerSchedule": "معدل التسميد ونوع السماد المناسب وأوقاته (مثال: مرة كل شهر خلال فصلي الربيع والصيف بسماد متعادل)",
  "healthStatus": "الحالة الصحية الحالية الظاهرة للنبات في الصورة (مثال: سليمة، مصابة بمرض، نقص ري، حروق شمس، تعفن جذور)",
  "diseaseName": "اسم المرض أو الآفة إن وجد باللغة العربية والإنجليزية (اكتب 'سليم ولا يوجد مرض' إذا كان النبات سليماً)",
  "confidence": 0.95,
  "diseaseCause": "سبب المرض أو المشكلة الظاهرة بالتفصيل كالفطريات أو الآفات أو سوء الرعاية (اكتب 'لا يوجد' إذا كان النبات سليماً)",
  "symptoms": "الأعراض المرضية الظاهرة على أوراق أو سيقان النبات بالتفصيل (أو اكتب 'لا توجد أعراض مرضية ونمو سليم')",
  "treatment": "طريقة العلاج المفصلة والخطوات العملية لمعالجة المشكلة أو المرض (اكتب 'لا يتطلب علاجاً' إذا كان النبات سليماً)",
  "prevention": "نصائح وخطوات وقائية لحماية النبتة من تكرار الإصابة مستقبلاً وتعزيز مناعتها",
  "toxicity": "مدى سمية النبتة للحيوانات الأليفة (القطط والكلاب) والأطفال (مثال: سامة للقطط والكلاب عند بلعها، أو آمنة تماماً وغير سامة)",
  "growthRate": "معدل نمو النبتة (سريع، متوسط، بطيء)",
  "lifespan": "العمر الافتراضي أو طبيعة النبتة (مثال: معمرة، حولية، ثنائية الحول)",
  "generalCareTips": "نصائح وإرشادات عامة إضافية للعناية اليومية والمستمرة بالنبات لضمان نموه بشكل صحي"
}
''';

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      final response = await model.generateContent(content);
      final responseText = response.text;
      if (responseText == null) {
        throw Exception('لم يتم استقبال أي رد من خوادم Gemini API.');
      }

      // Clean response text if it contains markdown block code
      var cleanJson = responseText.trim();
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.substring(7);
      }
      if (cleanJson.startsWith('```')) {
        cleanJson = cleanJson.substring(3);
      }
      if (cleanJson.endsWith('```')) {
        cleanJson = cleanJson.substring(0, cleanJson.length - 3);
      }
      cleanJson = cleanJson.trim();

      final Map<String, dynamic> parsedJson = json.decode(cleanJson);
      return PlantAnalysisModel.fromJson(parsedJson);
    } catch (e) {
      throw Exception('فشل تحليل الصورة: $e');
    }
  }

  /// Sends a user message along with conversation history to Gemini for the chatbot assistant.
  Future<String> getChatResponse({
    required List<Content> chatHistory,
    required String apiKey,
  }) async {
    if (apiKey.trim().isEmpty) {
      throw Exception('يرجى ضبط مفتاح Gemini API Key في شاشة الإعدادات أولاً.');
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
        systemInstruction: Content.system(
          'أنت مساعد ذكي متخصص وخبير في علم النباتات وأمراضها. أجب على استفسارات المستخدمين باللغة العربية الفصحى بكل وضوح ولطف وتقديم نصائح عملية.',
        ),
      );

      final history = chatHistory.take(chatHistory.length - 1).toList();
      final chat = model.startChat(history: history);
      final response = await chat.sendMessage(chatHistory.last);
      return response.text ?? 'عذراً، لم أستطع توليد رد في الوقت الحالي.';
    } catch (e) {
      throw Exception('فشل الاتصال بالمساعد الذكي: $e');
    }
  }
}
