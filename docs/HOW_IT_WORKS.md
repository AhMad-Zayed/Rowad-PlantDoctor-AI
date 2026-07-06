# كيف يعمل طبيب النباتات الذكي؟ (آلية عمل Gemini API)

يعتمد مشروع **Rowad-PlantDoctor-AI** على دمج تقنيات الذكاء الاصطناعي من خلال **Gemini API** لتحليل صور النباتات وتشخيص حالتها. يوضح هذا الملف التدفق التقني للبيانات وكيفية استدعاء الـ API بطريقة آمنة.

## 🔄 تدفق البيانات (Data Flow)

1. **المدخلات (Input):**
   - يقوم المستخدم باستخدام التطبيق لاختيار صورة (إما بالتقاطها عبر الكاميرا أو اختيارها من معرض الصور).
   - تُحوَّل الصورة داخل تطبيق Flutter إلى بيانات بايت (Bytes) لتهيئتها للإرسال.

2. **نموذج الذكاء الاصطناعي (Model):**
   - يتم استخدام حزمة `google_generative_ai` في Flutter.
   - النموذج المستخدم غالباً هو `gemini-1.5-flash` أو النماذج المتخصصة بالرؤية (Vision Models) لقدرتها العالية على تحليل الصور والنصوص معاً بسرعات كبيرة.
   - يتم إرفاق "موجّه نصي" (Prompt) مع الصورة، مثل:
     *"أنت خبير في أمراض النباتات. يرجى تحليل هذه الصورة، وتحديد اسم النبتة، وتشخيص المرض إن وجد، واقتراح خطوات لعلاجها."*

3. **المخرجات (Output):**
   - يستقبل التطبيق استجابة (Response) من Gemini API تحتوي على تقرير مفصّل.
   - تُعالج هذه الاستجابة لتُعرض للمستخدم في واجهة سهلة القراءة.

## 🔐 حماية البيانات والمفاتيح (Security)

لضمان عدم تسريب المفتاح السري (API Key) الخاص بـ Gemini، يعتمد المشروع على التالي:
- **عدم التضمين المباشر:** لا يتم كتابة الـ API Key بشكل مباشر (Hardcoded) داخل ملفات الكود (مثل `main.dart`).
- **استخدام ملفات البيئة (`.env`):** يتم قراءة المفتاح من ملف `.env` محلي غير مرفوع على GitHub (مستثنى عبر `.gitignore`).
- **كيفية الاستخدام:** يقوم التطبيق بتحميل المفتاح في الذاكرة عند بدء التشغيل وتمريره إلى كائن `GenerativeModel`.

## 💻 مثال تقريبي للكود (Code Snippet)

```dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';

Future<String?> diagnosePlant(File imageFile) async {
  // قراءة المفتاح بأمان (من متغيرات البيئة)
  final apiKey = const String.fromEnvironment('GEMINI_API_KEY');
  
  if (apiKey.isEmpty) {
    throw Exception("API Key is missing!");
  }

  // تهيئة النموذج
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: apiKey,
  );

  // إعداد النص (Prompt) والصورة
  final prompt = TextPart("قم بتشخيص المرض في هذه النبتة واقترح طرق العلاج خطوة بخطوة.");
  final imageBytes = await imageFile.readAsBytes();
  final imagePart = DataPart('image/jpeg', imageBytes);

  // استدعاء Gemini API
  final response = await model.generateContent([
    Content.multi([prompt, imagePart])
  ]);

  // إرجاع النتيجة
  return response.text;
}
```

> **ملاحظة:** الكود أعلاه هو مثال توضيحي ومبسّط لآلية العمل، وقد تختلف تفاصيل التنفيذ قليلاً داخل مجلد `lib` في التطبيق الفعلي.
