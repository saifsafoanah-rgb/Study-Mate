import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';
import 'update_page.dart';

final ValueNotifier<ThemeMode> appThemeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  appThemeMode.value = prefs.getBool('dark_theme') == true ? ThemeMode.dark : ThemeMode.light;
  runApp(const StudyMateApp());
}

Future<void> toggleAppTheme() async {
  final dark = appThemeMode.value != ThemeMode.dark;
  appThemeMode.value = dark ? ThemeMode.dark : ThemeMode.light;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('dark_theme', dark);
}

const ink = Color(0xFF17152B);
const purple = Color(0xFF7057E8);
const pale = Color(0xFFF4F1FF);

class StudyMateApp extends StatelessWidget {
  const StudyMateApp({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
    valueListenable: appThemeMode,
    builder: (context, mode, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyMate',
      themeMode: mode,
      theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: const Color(0xFFF8F8FC), colorScheme: ColorScheme.fromSeed(seedColor: purple)),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark, scaffoldBackgroundColor: const Color(0xFF10101B), colorScheme: ColorScheme.fromSeed(seedColor: purple, brightness: Brightness.dark), cardColor: const Color(0xFF1D1B2B), appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF10101B), foregroundColor: Colors.white), navigationBarTheme: const NavigationBarThemeData(backgroundColor: Color(0xFF191727), indicatorColor: Color(0xFF493A7C))),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedClass = 8;
  int tab = 0;
  String selectedStream = 'সাধারণ মাধ্যমিক';

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: IndexedStack(index: tab, children: [_home(), const BuddiesPage(), PracticePage(selectedClass: selectedClass), const SimplePage(title: 'নোটস', subtitle: 'তোমার পড়ার নোট এখানে সাজানো থাকবে।', icon: Icons.menu_book_outlined), const ProgressPage()])),
    bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (v) => setState(() => tab = v), destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'হোম'),
      NavigationDestination(icon: Icon(Icons.face_retouching_natural), label: 'গাইড'),
      NavigationDestination(icon: Icon(Icons.quiz_outlined), label: 'প্র্যাকটিস'),
      NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: 'নোটস'),
      NavigationDestination(icon: Icon(Icons.person_outline), label: 'প্রোফাইল'),
    ]),
  );

  Widget _home() => ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 28), children: [
    Row(children: [
      Container(height: 46, width: 46, decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.school_rounded, color: purple, size: 27)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('StudyMate', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface)), Text('শেখা হোক আরও সহজ', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12))])),
      IconButton(tooltip: appThemeMode.value == ThemeMode.dark ? 'Light theme' : 'Dark theme', onPressed: toggleAppTheme, icon: Icon(appThemeMode.value == ThemeMode.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded)),
      IconButton(tooltip: 'নিরাপদ আপডেট', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UpdatePage())), icon: const Icon(Icons.system_update_alt_rounded)),
    ]),
    const SizedBox(height: 24),
    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF7660EA), Color(0xFF4E3CB8)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('আজ থেকেই শুরু হোক!', style: TextStyle(color: Colors.white70, fontSize: 13)), SizedBox(height: 8),
      Text('প্রতিদিন একটু একটু\nকরে এগিয়ে যাও।', style: TextStyle(color: Colors.white, fontSize: 23, height: 1.3, fontWeight: FontWeight.bold)),
      SizedBox(height: 15), Row(children: [Icon(Icons.auto_awesome, color: Colors.white, size: 17), SizedBox(width: 7), Text('তোমার পড়াশোনার সঙ্গী', style: TextStyle(color: Colors.white, fontSize: 12))]),
    ])),
    const SizedBox(height: 26),
    Text('তোমার শ্রেণি নির্বাচন করো', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
    const SizedBox(height: 12),
    Wrap(spacing: 9, runSpacing: 9, children: List.generate(5, (i) { final c = i + 6; final active = selectedClass == c; return ChoiceChip(label: Text('Class $c'), selected: active, onSelected: (_) => setState(() => selectedClass = c), selectedColor: pale, labelStyle: TextStyle(color: active ? purple : Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w700), side: BorderSide(color: active ? purple : Colors.black12)); })),
    const SizedBox(height: 20),
    Text('শিক্ষাধারা নির্বাচন করো', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
    const SizedBox(height: 10),
    Wrap(spacing: 9, runSpacing: 9, children: [
      ChoiceChip(label: const Text('সাধারণ মাধ্যমিক'), selected: selectedStream == 'সাধারণ মাধ্যমিক', onSelected: (_) => setState(() => selectedStream = 'সাধারণ মাধ্যমিক'), selectedColor: pale),
      ChoiceChip(label: const Text('দাখিল মাদ্রাসা'), selected: selectedStream == 'দাখিল মাদ্রাসা', onSelected: (_) => setState(() => selectedStream = 'দাখিল মাদ্রাসা'), selectedColor: pale),
    ]),
    const SizedBox(height: 25),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('বিষয়সমূহ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)), Text('$selectedStream • Class $selectedClass', style: const TextStyle(color: purple, fontWeight: FontWeight.w700))]),
    const SizedBox(height: 12),
    GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.65, children: [
      SubjectTile(title: 'বাংলা', subtitle: 'ভাষা ও সাহিত্য', icon: Icons.translate, color: Color(0xFFEFF7F1), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChapterLibraryPage(selectedClass: selectedClass, initialSubject: 'বাংলা')))),
      SubjectTile(title: 'English', subtitle: 'Grammar & Reading', icon: Icons.language, color: Color(0xFFEEF3FF), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChapterLibraryPage(selectedClass: selectedClass, initialSubject: 'English')))),
      SubjectTile(title: 'গণিত', subtitle: 'অনুশীলন ও সমাধান', icon: Icons.calculate_outlined, color: Color(0xFFFFF4E8), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChapterLibraryPage(selectedClass: selectedClass, initialSubject: 'গণিত')))),
      SubjectTile(title: 'বিজ্ঞান', subtitle: 'ধারণা ও আবিষ্কার', icon: Icons.science_outlined, color: Color(0xFFF4EEFF), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChapterLibraryPage(selectedClass: selectedClass, initialSubject: 'বিজ্ঞান')))),
    ]),
    const SizedBox(height: 22),
    Text('দ্রুত শুরু করো', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
    const SizedBox(height: 12),
    _quick(Icons.menu_book_rounded, 'অধ্যায়ভিত্তিক লেসন', 'লেসন পড়ো ও অধ্যায় শেষে MCQ দাও', () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChapterLibraryPage(selectedClass: selectedClass)))),
    _quick(Icons.play_circle_outline, 'MCQ Quiz', 'নিজেকে যাচাই করো', () => setState(() => tab = 2)),
    _quick(Icons.note_alt_outlined, 'আমার নোটস', 'গুরুত্বপূর্ণ বিষয় গুছিয়ে রাখো', () => setState(() => tab = 3)),
  ]);

  Widget _quick(IconData icon, String title, String subtitle, VoidCallback action) => Card(elevation: 0, color: Theme.of(context).cardColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), child: ListTile(onTap: action, leading: CircleAvatar(backgroundColor: pale, child: Icon(icon, color: purple)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(subtitle), trailing: const Icon(Icons.arrow_forward_ios, size: 15)));
}

class SubjectTile extends StatelessWidget {
  final String title, subtitle; final IconData icon; final Color color; final VoidCallback onTap;
  const SubjectTile({super.key, required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(17), child: Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(17), border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)), child: Row(children: [
    Container(width: 39, height: 39, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Theme.of(context).colorScheme.onSurface)), const SizedBox(width: 10),
    Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)), const SizedBox(height: 3), Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant))])),
  ])));
}


class QuizQuestion {
  final String question;
  final List<String> options;
  final int answer;
  final String explanation;
  const QuizQuestion(this.question, this.options, this.answer, this.explanation);
}

const Map<String, List<QuizQuestion>> quizQuestions = {
  'বাংলা': [
    QuizQuestion('“সোনার তরী” কবিতার রচয়িতা কে?', ['কাজী নজরুল ইসলাম', 'রবীন্দ্রনাথ ঠাকুর', 'জসীমউদ্দীন', 'মাইকেল মধুসূদন দত্ত'], 1, '“সোনার তরী” রবীন্দ্রনাথ ঠাকুরের লেখা।'),
    QuizQuestion('বাংলা বর্ণমালায় স্বরবর্ণ কয়টি?', ['৭টি', '৯টি', '১১টি', '১২টি'], 2, 'বাংলা স্বরবর্ণ ১১টি।'),
    QuizQuestion('“আকাশ” শব্দের সমার্থক শব্দ কোনটি?', ['পবন', 'গগন', 'ধরণি', 'সলিল'], 1, 'গগন শব্দের অর্থ আকাশ।'),
    QuizQuestion('“দিন” শব্দের বিপরীত শব্দ কী?', ['রাত', 'সকাল', 'দুপুর', 'আলো'], 0, 'দিনের বিপরীত শব্দ রাত।'),
    QuizQuestion('“সে স্কুলে যায়”—এখানে “সে” কোন পদ?', ['বিশেষ্য', 'বিশেষণ', 'সর্বনাম', 'ক্রিয়া'], 2, '“সে” সর্বনাম পদ।'),
  ],
  'English': [
    QuizQuestion('Choose the plural of “Child”.', ['Childs', 'Children', 'Childes', 'Childrens'], 1, 'The plural form is children.'),
    QuizQuestion('What is the past tense of “Go”?', ['Goed', 'Gone', 'Went', 'Going'], 2, 'The simple past form is went.'),
    QuizQuestion('Choose the correct article: “___ apple”.', ['A', 'An', 'The only', 'No article'], 1, 'Use “an” before a vowel sound.'),
    QuizQuestion('Which word is an adjective?', ['Quickly', 'Beauty', 'Beautiful', 'Run'], 2, 'Beautiful is an adjective.'),
    QuizQuestion('What is the opposite of “Difficult”?', ['Hard', 'Easy', 'Strong', 'Heavy'], 1, 'Easy is the opposite of difficult.'),
  ],
  'গণিত': [
    QuizQuestion('১২ × ৮ = কত?', ['৮৬', '৯৬', '১০৬', '১১৬'], 1, '১২ × ৮ = ৯৬।'),
    QuizQuestion('একটি ত্রিভুজের তিন কোণের সমষ্টি কত?', ['৯০°', '১৮০°', '২৭০°', '৩৬০°'], 1, 'ত্রিভুজের কোণগুলোর সমষ্টি ১৮০°।'),
    QuizQuestion('২৫-এর ২০% কত?', ['৪', '৫', '১০', '১৫'], 1, '২৫ × ২০ ÷ ১০০ = ৫।'),
    QuizQuestion('২, ৪, ৬, ৮, পরের সংখ্যা কত?', ['৯', '১০', '১১', '১২'], 1, 'প্রতিবার ২ যোগ হচ্ছে।'),
    QuizQuestion('এক ডজনে কয়টি?', ['১০', '১১', '১২', '২৪'], 2, 'এক ডজন = ১২টি।'),
  ],
  'বিজ্ঞান': [
    QuizQuestion('উদ্ভিদ কোন প্রক্রিয়ায় খাদ্য তৈরি করে?', ['শ্বসন', 'সালোকসংশ্লেষণ', 'বাষ্পীভবন', 'পরিপাক'], 1, 'উদ্ভিদ সালোকসংশ্লেষণের মাধ্যমে খাদ্য তৈরি করে।'),
    QuizQuestion('পানির রাসায়নিক সংকেত কোনটি?', ['CO₂', 'O₂', 'H₂O', 'NaCl'], 2, 'পানির সংকেত H₂O।'),
    QuizQuestion('মানুষ শ্বাস নেওয়ার সময় কোন গ্যাস গ্রহণ করে?', ['কার্বন ডাই-অক্সাইড', 'অক্সিজেন', 'নাইট্রোজেন', 'হাইড্রোজেন'], 1, 'শরীরের জন্য অক্সিজেন প্রয়োজন।'),
    QuizQuestion('পৃথিবীর প্রাকৃতিক উপগ্রহ কোনটি?', ['সূর্য', 'মঙ্গল', 'চাঁদ', 'শুক্র'], 2, 'চাঁদ পৃথিবীর প্রাকৃতিক উপগ্রহ।'),
    QuizQuestion('স্বাভাবিক চাপে পানি কত ডিগ্রিতে ফোটে?', ['০°', '৫০°', '১০০°', '১৫০°'], 2, 'স্বাভাবিক চাপে পানি ১০০° সেলসিয়াসে ফোটে।'),
  ],
};

// Class-wise practice question bank. These are supplementary practice questions, not verbatim textbook questions.
const Map<int, Map<String, List<QuizQuestion>>> classQuizBank = {
  6: {
    'বাংলা': [
      QuizQuestion("“আম” কোন পদ?", ["বিশেষ্য","ক্রিয়া","সর্বনাম","অব্যয়"], 0, "আম একটি ফলের নাম, তাই বিশেষ্য।"),
      QuizQuestion("“সুন্দর” শব্দটি কোন পদ?", ["বিশেষ্য","বিশেষণ","ক্রিয়া","সর্বনাম"], 1, "সুন্দর শব্দটি গুণ বোঝায়, তাই বিশেষণ।"),
      QuizQuestion("“আমি” কোন ধরনের শব্দ?", ["বিশেষ্য","সর্বনাম","ক্রিয়া","অব্যয়"], 1, "আমি বক্তাকে বোঝায়, তাই সর্বনাম।"),
      QuizQuestion("“রাত”-এর বিপরীত শব্দ কী?", ["দিন","সন্ধ্যা","অন্ধকার","চাঁদ"], 0, "রাতের বিপরীত শব্দ দিন।"),
      QuizQuestion("বাংলা বর্ণমালায় স্বরবর্ণ কয়টি?", ["৯টি","১০টি","১১টি","১২টি"], 2, "বাংলা স্বরবর্ণ ১১টি।"),
    ],
    'English': [
      QuizQuestion("What is the plural of “book”?", ["Bookes","Books","Bookies","Book"], 1, "Most nouns form the plural by adding -s."),
      QuizQuestion("Choose the correct article: ___ orange.", ["A","An","The","No article"], 1, "Use “an” before a vowel sound."),
      QuizQuestion("What is the opposite of “hot”?", ["Warm","Cold","Dry","Fast"], 1, "Cold is the opposite of hot."),
      QuizQuestion("Which one is a verb?", ["Run","Blue","Table","Kind"], 0, "Run expresses an action, so it is a verb."),
      QuizQuestion("Choose the correct pronoun: Rina is a girl. ___ is kind.", ["He","It","She","They"], 2, "She is used for a girl or woman."),
    ],
    'গণিত': [
      QuizQuestion("২৪ + ১৬ = কত?", ["৩০","৩৮","৪০","৪২"], 2, "২৪ + ১৬ = ৪০।"),
      QuizQuestion("৯ × ৭ = কত?", ["৫৬","৬৩","৭২","৬৭"], 1, "৯ × ৭ = ৬৩।"),
      QuizQuestion("১/২ + ১/২ = কত?", ["১/২","১","২","১/৪"], 1, "সমান হরের ভগ্নাংশ যোগ করলে ২/২ = ১।"),
      QuizQuestion("একটি বর্গের কয়টি বাহু?", ["৩টি","৪টি","৫টি","৬টি"], 1, "বর্গের চারটি সমান বাহু থাকে।"),
      QuizQuestion("১০০-এর ১০% কত?", ["৫","১০","২০","৫০"], 1, "১০০ × ১০ ÷ ১০০ = ১০।"),
    ],
    'বিজ্ঞান': [
      QuizQuestion("উদ্ভিদ খাদ্য তৈরি করে কোন প্রক্রিয়ায়?", ["শ্বসন","সালোকসংশ্লেষণ","পরিপাক","বাষ্পীভবন"], 1, "উদ্ভিদ সালোকসংশ্লেষণের মাধ্যমে খাদ্য তৈরি করে।"),
      QuizQuestion("মানুষ শ্বাস নেওয়ার সময় কোন গ্যাস গ্রহণ করে?", ["অক্সিজেন","কার্বন ডাই-অক্সাইড","হিলিয়াম","হাইড্রোজেন"], 0, "শরীরের কোষের জন্য অক্সিজেন প্রয়োজন।"),
      QuizQuestion("পানির কঠিন অবস্থা কী?", ["বাষ্প","বরফ","বৃষ্টি","শিশির"], 1, "বরফ হলো পানির কঠিন অবস্থা।"),
      QuizQuestion("পৃথিবীর প্রাকৃতিক উপগ্রহ কোনটি?", ["সূর্য","মঙ্গল","চাঁদ","শুক্র"], 2, "চাঁদ পৃথিবীর প্রাকৃতিক উপগ্রহ।"),
      QuizQuestion("কোন অঙ্গ দিয়ে আমরা দেখি?", ["কান","নাক","চোখ","জিহ্বা"], 2, "চোখ দিয়ে আমরা দেখি।"),
    ],
  },
  7: {
    'বাংলা': [
      QuizQuestion("“পাখি উড়ে”—বাক্যে ক্রিয়া কোনটি?", ["পাখি","উড়ে","বাক্য","কোনোটিই নয়"], 1, "উড়ে কাজ বোঝায়, তাই এটি ক্রিয়া।"),
      QuizQuestion("“অতি” কোন ধরনের শব্দাংশ?", ["উপসর্গ","প্রত্যয়","বিভক্তি","সমাস"], 0, "অতি শব্দটি উপসর্গ হিসেবে ব্যবহৃত হয়।"),
      QuizQuestion("“নদী” শব্দের বহুবচন কোনটি?", ["নদীরা","নদীগুলো","নদীটি","নদীর"], 1, "নদীগুলো বহুবচন বোঝায়।"),
      QuizQuestion("“সৎ” শব্দের বিপরীত কী?", ["ভালো","অসৎ","সত্য","সুন্দর"], 1, "সৎ-এর বিপরীত অসৎ।"),
      QuizQuestion("“গগন” শব্দের অর্থ কী?", ["পৃথিবী","আকাশ","সমুদ্র","বাতাস"], 1, "গগন অর্থ আকাশ।"),
    ],
    'English': [
      QuizQuestion("What is the past form of “eat”?", ["Eated","Ate","Eaten","Eating"], 1, "The simple past form of eat is ate."),
      QuizQuestion("Which is an adjective?", ["Slowly","Slow","Slowness","Slow down"], 1, "Slow describes a noun, so it is an adjective."),
      QuizQuestion("Choose the correct sentence.", ["He go to school.","He goes to school.","He going school.","He gone school."], 1, "With he/she/it in the simple present, use goes."),
      QuizQuestion("What is the plural of “mouse”?", ["Mouses","Mice","Mices","Mouse"], 1, "The irregular plural of mouse is mice."),
      QuizQuestion("Choose the preposition: The book is ___ the table.", ["in","on","at","by"], 1, "On indicates the book rests on the table surface."),
    ],
    'গণিত': [
      QuizQuestion("১৫ × ১২ = কত?", ["১৬০","১৭০","১৮০","১৯০"], 2, "১৫ × ১২ = ১৮০।"),
      QuizQuestion("৩/৪-এর সমতুল ভগ্নাংশ কোনটি?", ["৬/৮","২/৮","৩/৮","৪/৬"], 0, "লব ও হরকে ২ দিয়ে গুণ করলে ৬/৮ হয়।"),
      QuizQuestion("একটি ত্রিভুজের কোণগুলোর সমষ্টি কত?", ["৯০°","১৮০°","২৭০°","৩৬০°"], 1, "ত্রিভুজের অন্তঃকোণগুলোর সমষ্টি ১৮০°।"),
      QuizQuestion("২০০-এর ২৫% কত?", ["২৫","৪০","৫০","৭৫"], 2, "২০০ × ২৫ ÷ ১০০ = ৫০।"),
      QuizQuestion("x + ৭ = ১২ হলে x কত?", ["৩","৪","৫","৬"], 2, "x = ১২ − ৭ = ৫।"),
    ],
    'বিজ্ঞান': [
      QuizQuestion("পদার্থের কয়টি প্রচলিত অবস্থা শেখানো হয়?", ["২টি","৩টি","৪টি","৫টি"], 1, "কঠিন, তরল ও গ্যাসীয়—তিনটি প্রচলিত অবস্থা।"),
      QuizQuestion("উদ্ভিদের কোন অংশ পানি শোষণ করে?", ["পাতা","ফুল","মূল","ফল"], 2, "মূল মাটি থেকে পানি ও খনিজ লবণ শোষণ করে।"),
      QuizQuestion("শব্দ চলাচলের জন্য কী প্রয়োজন?", ["মাধ্যম","শূন্যস্থান","শুধু আলো","চুম্বক"], 0, "শব্দ চলাচলের জন্য বস্তুগত মাধ্যম প্রয়োজন।"),
      QuizQuestion("মানবদেহে রক্ত পাম্প করে কোন অঙ্গ?", ["ফুসফুস","হৃদপিণ্ড","যকৃত","কিডনি"], 1, "হৃদপিণ্ড রক্ত সারা শরীরে পাম্প করে।"),
      QuizQuestion("পৃথিবী সূর্যকে একবার প্রদক্ষিণ করতে প্রায় কত সময় নেয়?", ["এক দিন","এক মাস","এক বছর","এক ঘণ্টা"], 2, "পৃথিবীর একবার সূর্য-প্রদক্ষিণে প্রায় এক বছর লাগে।"),
    ],
  },
  8: {
    'বাংলা': [
      QuizQuestion("“বিদ্যালয়” শব্দের সন্ধিবিচ্ছেদ কোনটি?", ["বিদ্যা + আলয়","বিদ + আলয়","বিদ্য + লয়","বি + দ্যালয়"], 0, "বিদ্যালয় = বিদ্যা + আলয়।"),
      QuizQuestion("“যে উপকার করে”—এক কথায় কী?", ["অকৃতজ্ঞ","উপকারী","অপকারী","কৃপণ"], 1, "যে উপকার করে সে উপকারী।"),
      QuizQuestion("“নীল আকাশ”—এখানে “নীল” কী?", ["বিশেষ্য","বিশেষণ","ক্রিয়া","সর্বনাম"], 1, "নীল আকাশের গুণ প্রকাশ করে, তাই বিশেষণ।"),
      QuizQuestion("“কবিগুরু” উপাধিটি কার?", ["কাজী নজরুল ইসলাম","রবীন্দ্রনাথ ঠাকুর","জসীমউদ্দীন","সুকান্ত ভট্টাচার্য"], 1, "রবীন্দ্রনাথ ঠাকুরকে কবিগুরু বলা হয়।"),
      QuizQuestion("“অমর” শব্দের বিপরীত কী?", ["অজর","মরণশীল","অক্ষয়","চিরন্তন"], 1, "অমর-এর বিপরীত মরণশীল।"),
    ],
    'English': [
      QuizQuestion("Choose the passive form: “They play football.”", ["Football is played by them.","Football played them.","Football was play.","They are played football."], 0, "Simple present passive uses is/am/are + past participle."),
      QuizQuestion("What is the comparative form of “good”?", ["Gooder","Best","Better","More good"], 2, "The comparative form of good is better."),
      QuizQuestion("Choose the correct spelling.", ["Environment","Enviroment","Envirenment","Environmant"], 0, "Environment is the correct spelling."),
      QuizQuestion("Which is a conjunction?", ["Because","Quickly","Beautiful","Under"], 0, "Because joins clauses and gives a reason."),
      QuizQuestion("Choose the correct tense: She ___ here since 2020.", ["lives","lived","has lived","is live"], 2, "Since with an action continuing to now commonly takes present perfect."),
    ],
    'গণিত': [
      QuizQuestion("(−৫) + ৮ = কত?", ["−১৩","−৩","৩","১৩"], 2, "−৫ + ৮ = ৩।"),
      QuizQuestion("২x = ১৮ হলে x কত?", ["৬","৮","৯","১২"], 2, "উভয় পাশে ২ দিয়ে ভাগ করলে x = ৯।"),
      QuizQuestion("একটি বৃত্তের পরিধির সূত্র কোনটি?", ["πr²","2πr","l×w","4a"], 1, "বৃত্তের পরিধি = 2πr।"),
      QuizQuestion("০.২৫ ভগ্নাংশে কত?", ["১/২","১/৩","১/৪","৩/৪"], 2, "০.২৫ = ২৫/১০০ = ১/৪।"),
      QuizQuestion("একটি আয়তক্ষেত্রের দৈর্ঘ্য ৮ ও প্রস্থ ৫ হলে ক্ষেত্রফল কত?", ["১৩","২৬","৪০","৮০"], 2, "ক্ষেত্রফল = দৈর্ঘ্য × প্রস্থ = ৮ × ৫ = ৪০।"),
    ],
    'বিজ্ঞান': [
      QuizQuestion("কোষের নিয়ন্ত্রণকেন্দ্র কোনটি?", ["কোষপ্রাচীর","নিউক্লিয়াস","সাইটোপ্লাজম","রাইবোজোম"], 1, "নিউক্লিয়াস কোষের কার্যক্রম নিয়ন্ত্রণ করে।"),
      QuizQuestion("বল-এর SI একক কী?", ["জুল","ওয়াট","নিউটন","পাস্কাল"], 2, "বলের SI একক নিউটন।"),
      QuizQuestion("অম্ল নীল লিটমাসকে কী রঙে পরিণত করে?", ["লাল","সবুজ","নীল","হলুদ"], 0, "অম্ল নীল লিটমাসকে লাল করে।"),
      QuizQuestion("শ্বাসক্রিয়ায় প্রধানত কোন গ্যাস ত্যাগ হয়?", ["অক্সিজেন","কার্বন ডাই-অক্সাইড","হাইড্রোজেন","নাইট্রোজেন"], 1, "শ্বাসক্রিয়ায় কার্বন ডাই-অক্সাইড উৎপন্ন ও ত্যাগ হয়।"),
      QuizQuestion("আলোর প্রতিফলনে আপতন কোণ ও প্রতিফলন কোণের সম্পর্ক কী?", ["অসমান","সমান","যোগফল ৯০°","সবসময় শূন্য"], 1, "প্রতিফলনের সূত্র অনুযায়ী দুই কোণ সমান।"),
    ],
  },
  9: {
    'বাংলা': [
      QuizQuestion("“মেঘনাদবধ কাব্য”-এর রচয়িতা কে?", ["রবীন্দ্রনাথ ঠাকুর","মাইকেল মধুসূদন দত্ত","কাজী নজরুল ইসলাম","বঙ্কিমচন্দ্র"], 1, "মেঘনাদবধ কাব্য মাইকেল মধুসূদন দত্তের রচনা।"),
      QuizQuestion("“যে দেশের উপকার করে”—এক কথায় কী?", ["দেশদ্রোহী","দেশপ্রেমিক","পরদেশি","বিদেশি"], 1, "দেশের মঙ্গল কামনা ও কাজ করেন যিনি, তিনি দেশপ্রেমিক।"),
      QuizQuestion("“রাজপুত্র” কোন সমাসের উদাহরণ?", ["দ্বন্দ্ব","কর্মধারয়","ষষ্ঠী তৎপুরুষ","বহুব্রীহি"], 2, "রাজার পুত্র—ষষ্ঠী তৎপুরুষ সমাস।"),
      QuizQuestion("“অগ্নি” শব্দের সমার্থক কোনটি?", ["অনল","অনিল","অম্বর","অর্ণব"], 0, "অনল শব্দের অর্থ আগুন।"),
      QuizQuestion("“সে বই পড়ে”—বাক্যটি কোন কাল?", ["অতীত","বর্তমান","ভবিষ্যৎ","পুরাঘটিত অতীত"], 1, "পড়ে ক্রিয়াটি সাধারণ বর্তমান কাল বোঝায়।"),
    ],
    'English': [
      QuizQuestion("Choose the correct conditional: If I were rich, I ___ travel.", ["will","would","am","have"], 1, "Second conditional uses would + base verb."),
      QuizQuestion("What is the synonym of “rapid”?", ["Slow","Fast","Weak","Late"], 1, "Rapid means fast or quick."),
      QuizQuestion("Choose the correct reported speech: He said, “I am tired.”", ["He said that he is tired.","He said that he was tired.","He says tired.","He said I tired."], 1, "In reported speech, am commonly backshifts to was."),
      QuizQuestion("Which sentence is correct?", ["Neither of them are ready.","Neither of them is ready.","Neither are ready person.","Neither them is ready."], 1, "Neither is generally treated as singular in formal grammar."),
      QuizQuestion("What is the noun form of “decide”?", ["Decisive","Decision","Decided","Decidingly"], 1, "Decision is the noun form of decide."),
    ],
    'গণিত': [
      QuizQuestion("x² − ৯ এর উৎপাদক কোনটি?", ["(x−৯)(x+১)","(x−৩)(x+৩)","(x−৩)²","(x+৯)(x−১)"], 1, "বর্গের অন্তর: x²−৩² = (x−৩)(x+৩)।"),
      QuizQuestion("sin ৩০° এর মান কত?", ["০","১/২","√৩/২","১"], 1, "sin ৩০° = ১/২।"),
      QuizQuestion("একটি সমকোণী ত্রিভুজে অতিভুজের বিপরীত কোণ কত?", ["৩০°","৪৫°","৬০°","৯০°"], 3, "সমকোণী ত্রিভুজে একটি কোণ ৯০°।"),
      QuizQuestion("১০, ১২, ১৪-এর গড় কত?", ["১১","১২","১৩","১৪"], 1, "গড় = (১০+১২+১৪)/৩ = ১২।"),
      QuizQuestion("বৃত্তের ক্ষেত্রফল কোনটি?", ["2πr","πr²","πd","r²/2"], 1, "বৃত্তের ক্ষেত্রফল = πr²।"),
    ],
    'বিজ্ঞান': [
      QuizQuestion("বৈদ্যুতিক প্রবাহের SI একক কী?", ["ভোল্ট","ওহম","অ্যাম্পিয়ার","ওয়াট"], 2, "তড়িৎ প্রবাহের SI একক অ্যাম্পিয়ার।"),
      QuizQuestion("DNA-এর পূর্ণরূপ কী?", ["Deoxyribonucleic acid","Dynamic nitrogen atom","Double nuclear acid","Deoxy nitrogen acid"], 0, "DNA-এর পূর্ণরূপ Deoxyribonucleic acid।"),
      QuizQuestion("নিউটনের দ্বিতীয় সূত্রের গাণিতিক রূপ কোনটি?", ["F = ma","E = mc²","V = IR","P = VI"], 0, "বল = ভর × ত্বরণ।"),
      QuizQuestion("pH ৭-এর কম হলে দ্রবণটি কেমন?", ["ক্ষারীয়","অম্লীয়","নিরপেক্ষ","লবণাক্ত"], 1, "২৫°C-এ pH ৭-এর কম হলে দ্রবণ অম্লীয়।"),
      QuizQuestion("মানবদেহে ইনসুলিন কোন অঙ্গ থেকে নিঃসৃত হয়?", ["যকৃত","অগ্ন্যাশয়","হৃদপিণ্ড","ফুসফুস"], 1, "অগ্ন্যাশয়ের বিটা কোষ ইনসুলিন নিঃসরণ করে।"),
    ],
  },
  10: {
    'বাংলা': [
      QuizQuestion("“পথের পাঁচালী” উপন্যাসের রচয়িতা কে?", ["শরৎচন্দ্র চট্টোপাধ্যায়","বিভূতিভূষণ বন্দ্যোপাধ্যায়","মানিক বন্দ্যোপাধ্যায়","তারাশঙ্কর বন্দ্যোপাধ্যায়"], 1, "পথের পাঁচালী বিভূতিভূষণ বন্দ্যোপাধ্যায়ের উপন্যাস।"),
      QuizQuestion("“বিদ্রোহী” কবিতার কবি কে?", ["রবীন্দ্রনাথ ঠাকুর","কাজী নজরুল ইসলাম","জসীমউদ্দীন","সুকান্ত ভট্টাচার্য"], 1, "বিদ্রোহী কবিতা কাজী নজরুল ইসলামের রচনা।"),
      QuizQuestion("“চোখের মণি” বাগধারার অর্থ কী?", ["চোখের রোগ","অতি প্রিয় ব্যক্তি","অপরিচিত ব্যক্তি","রাগী ব্যক্তি"], 1, "চোখের মণি অর্থ অত্যন্ত প্রিয় ব্যক্তি।"),
      QuizQuestion("“উন্নতি” শব্দের বিপরীত কী?", ["অগ্রগতি","অবনতি","সমৃদ্ধি","বিকাশ"], 1, "উন্নতির বিপরীত অবনতি।"),
      QuizQuestion("“যিনি বক্তৃতা দেন”—এক কথায় কী?", ["শ্রোতা","বক্তা","লেখক","পাঠক"], 1, "যিনি বক্তব্য দেন, তিনি বক্তা।"),
    ],
    'English': [
      QuizQuestion("Choose the correct passive: “They have completed the work.”", ["The work has been completed.","The work is completed yesterday.","The work have completed.","The work had completing."], 0, "Present perfect passive uses has/have been + past participle."),
      QuizQuestion("What is the antonym of “generous”?", ["Kind","Selfish","Helpful","Honest"], 1, "Selfish is an opposite of generous."),
      QuizQuestion("Choose the correct tag: “You are coming, ___?”", ["are you","aren’t you","don’t you","won’t you"], 1, "A positive statement with are takes the negative tag aren’t you."),
      QuizQuestion("Which is a complex sentence?", ["He came and sat.","Work hard or fail.","I know that he is honest.","The sun rose."], 2, "It contains an independent clause and a dependent that-clause."),
      QuizQuestion("What is the adjective form of “beauty”?", ["Beautify","Beautiful","Beautifully","Beautician"], 1, "Beautiful is the adjective form of beauty."),
    ],
    'গণিত': [
      QuizQuestion("দ্বিঘাত সমীকরণ x² − ৫x + ৬ = ০-এর মূল কোন দুটি?", ["১ ও ৬","২ ও ৩","−২ ও −৩","৩ ও ৫"], 1, "(x−২)(x−৩)=০, তাই মূল ২ ও ৩।"),
      QuizQuestion("log₁₀ ১০০ এর মান কত?", ["১","২","১০","১০০"], 1, "১০² = ১০০, তাই log₁₀ ১০০ = ২।"),
      QuizQuestion("tan ৪৫° এর মান কত?", ["০","১/২","১","√৩"], 2, "tan ৪৫° = ১।"),
      QuizQuestion("একটি সমান্তর ধারার প্রথম পদ ৩, সাধারণ অন্তর ২ হলে ৫ম পদ কত?", ["৯","১০","১১","১৩"], 2, "৫ম পদ = ৩ + (৫−১)×২ = ১১।"),
      QuizQuestion("বৃত্তের ব্যাসার্ধ দ্বিগুণ হলে ক্ষেত্রফল কত গুণ হয়?", ["২ গুণ","৩ গুণ","৪ গুণ","৮ গুণ"], 2, "ক্ষেত্রফল πr²; ব্যাসার্ধ দ্বিগুণ হলে ক্ষেত্রফল ৪ গুণ হয়।"),
    ],
    'বিজ্ঞান': [
      QuizQuestion("আলোর বেগ শূন্যস্থানে প্রায় কত?", ["৩×১০⁶ m/s","৩×১০⁸ m/s","৩×১০¹⁰ m/s","৩০০ m/s"], 1, "শূন্যস্থানে আলোর বেগ প্রায় ৩×১০⁸ মিটার/সেকেন্ড।"),
      QuizQuestion("পর্যায় সারণিতে পারমাণবিক সংখ্যা কী নির্দেশ করে?", ["নিউট্রনের সংখ্যা","প্রোটনের সংখ্যা","নিউক্লিয়নের সংখ্যা","ইলেকট্রন স্তর"], 1, "পারমাণবিক সংখ্যা হলো নিউক্লিয়াসে প্রোটনের সংখ্যা।"),
      QuizQuestion("জিন প্রধানত কোথায় অবস্থিত?", ["ক্রোমোজোমে","কোষঝিল্লিতে","রাইবোজোমে","সাইটোপ্লাজমের পানিতে"], 0, "জিন হলো DNA-এর নির্দিষ্ট অংশ, যা ক্রোমোজোমে থাকে।"),
      QuizQuestion("ওহমের সূত্র কোনটি?", ["V = IR","F = ma","P = F/A","W = mg"], 0, "ওহমের সূত্র: বিভব পার্থক্য = প্রবাহ × রোধ।"),
      QuizQuestion("ওজোন স্তর প্রধানত কোন রশ্মি শোষণ করে?", ["অবলোহিত","অতিবেগুনি","রেডিও","দৃশ্যমান"], 1, "ওজোন স্তর সূর্যের ক্ষতিকর অতিবেগুনি রশ্মির বড় অংশ শোষণ করে।"),
    ],
  },
};


class PracticePage extends StatefulWidget {
  final int selectedClass;
  final String? initialSubject;
  const PracticePage({super.key, required this.selectedClass, this.initialSubject});
  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  late String subject;
  int questionIndex = 0;
  int? selectedOption;
  int score = 0;
  bool finished = false;

  @override
  void initState() {
    super.initState();
    subject = widget.initialSubject ?? 'বাংলা';
  }

  List<QuizQuestion> get questions => classQuizBank[widget.selectedClass]?[subject] ?? quizQuestions[subject]!;
  QuizQuestion get current => questions[questionIndex];

  void _changeSubject(String? value) {
    if (value == null) return;
    setState(() {
      subject = value;
      questionIndex = 0;
      selectedOption = null;
      score = 0;
      finished = false;
    });
  }

  void _next() {
    if (selectedOption == null) return;
    setState(() {
      if (selectedOption == current.answer) score++;
      if (questionIndex == questions.length - 1) {
        finished = true;
        StudyProgress.awardQuiz();
      } else {
        questionIndex++;
        selectedOption = null;
      }
    });
  }

  void _restart() {
    setState(() {
      questionIndex = 0;
      selectedOption = null;
      score = 0;
      finished = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('MCQ প্র্যাকটিস', style: TextStyle(fontWeight: FontWeight.bold))),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(18)), child: Text('Class ' + widget.selectedClass.toString() + ' • নিজের জ্ঞান যাচাই করো', style: const TextStyle(fontWeight: FontWeight.w700, color: ink))),
      const SizedBox(height: 20),
      const Text('বিষয় নির্বাচন করো', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        value: subject,
        decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)),
        items: quizQuestions.keys.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: _changeSubject,
      ),
      const SizedBox(height: 22),
      if (finished) ...[
        Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)), child: Column(children: [
          const Icon(Icons.emoji_events_rounded, color: Color(0xFFE6A23C), size: 64),
          const SizedBox(height: 12),
          const Text('কুইজ শেষ!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: ink)),
          const SizedBox(height: 8),
          Text('তোমার স্কোর: ' + score.toString() + ' / ' + questions.length.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: purple)),
          const SizedBox(height: 8),
          Text(score == questions.length ? 'দারুণ! সবগুলো উত্তর সঠিক হয়েছে।' : 'ভালো চেষ্টা! আবার অনুশীলন করলে আরও ভালো হবে।', textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton.icon(onPressed: _restart, icon: const Icon(Icons.refresh), label: const Text('আবার শুরু করো')),
        ])),
      ] else ...[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('প্রশ্ন ' + (questionIndex + 1).toString() + ' / ' + questions.length.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: ink)),
          Text('স্কোর: ' + score.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: purple)),
        ]),
        const SizedBox(height: 9),
        ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: (questionIndex + 1) / questions.length, minHeight: 7, backgroundColor: pale, color: purple)),
        const SizedBox(height: 18),
        Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Text(current.question, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, height: 1.5, color: ink))),
        const SizedBox(height: 14),
        ...List.generate(current.options.length, (i) {
          final chosen = selectedOption == i;
          final answered = selectedOption != null;
          final correct = current.answer == i;
          Color? fill;
          Color border = Colors.black12;
          if (answered && correct) { fill = const Color(0xFFE7F7EC); border = Colors.green; }
          else if (chosen && answered) { fill = const Color(0xFFFFEEEE); border = Colors.red; }
          return Container(margin: const EdgeInsets.only(bottom: 10), child: Material(
            color: fill ?? Colors.white,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: answered ? null : () => setState(() => selectedOption = i),
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15), decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: border)), child: Row(children: [
                CircleAvatar(radius: 14, backgroundColor: chosen ? purple : pale, child: Text(String.fromCharCode(65 + i), style: TextStyle(color: chosen ? Colors.white : purple, fontWeight: FontWeight.bold, fontSize: 12))),
                const SizedBox(width: 12),
                Expanded(child: Text(current.options[i], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                if (answered && correct) const Icon(Icons.check_circle, color: Colors.green),
                if (chosen && answered && !correct) const Icon(Icons.cancel, color: Colors.red),
              ])),
            ),
          ));
        }),
        if (selectedOption != null) Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: selectedOption == current.answer ? const Color(0xFFE7F7EC) : const Color(0xFFFFF4E8), borderRadius: BorderRadius.circular(14)), child: Text((selectedOption == current.answer ? 'সঠিক উত্তর!' : 'সঠিক উত্তর: ' + current.options[current.answer]) + '\n' + current.explanation, style: const TextStyle(height: 1.5))),
        const SizedBox(height: 12),
        SizedBox(height: 50, child: FilledButton(onPressed: selectedOption == null ? null : _next, child: Text(questionIndex == questions.length - 1 ? 'ফলাফল দেখো' : 'পরের প্রশ্ন'))),
      ],
    ]),
  );
}


class ChapterUnit {
  final String title, summary, lesson;
  final List<QuizQuestion> questions;
  const ChapterUnit(this.title, this.summary, this.lesson, this.questions);
}

const Map<String, List<ChapterUnit>> chapterLibrary = {
  'বাংলা': [
    ChapterUnit('গদ্য পাঠ ও অনুধাবন', 'মূলভাব, শব্দার্থ ও অনুধাবন', 'গদ্য পড়ার সময় প্রথমে অনুচ্ছেদের মূল বক্তব্য বোঝার চেষ্টা করবে। এরপর গুরুত্বপূর্ণ শব্দের অর্থ, লেখকের উদ্দেশ্য এবং অনুচ্ছেদ থেকে পাওয়া তথ্য নিজের ভাষায় লিখবে।\\n\\nঅনুশীলন: একটি অনুচ্ছেদ পড়ে ৩টি প্রশ্ন তৈরি করো—কে, কী, কেন।', [
      QuizQuestion('গদ্যের মূলভাব বলতে কী বোঝায়?', ['লেখার প্রধান বক্তব্য', 'শুধু কঠিন শব্দ', 'লেখকের নাম', 'বইয়ের প্রচ্ছদ'], 0, 'মূলভাব হলো লেখার প্রধান বক্তব্য বা কেন্দ্রীয় ধারণা।'),
      QuizQuestion('অনুধাবন যাচাইয়ের ভালো উপায় কোনটি?', ['না পড়ে উত্তর দেওয়া', 'নিজের ভাষায় বক্তব্য বলা', 'শুধু শিরোনাম মুখস্থ করা', 'সব শব্দ বাদ দেওয়া'], 1, 'নিজের ভাষায় বক্তব্য বলতে পারা অনুধাবনের লক্ষণ।'),
    ]),
    ChapterUnit('ব্যাকরণ: পদ পরিচয়', 'বিশেষ্য, সর্বনাম, বিশেষণ ও ক্রিয়া', 'বাক্যে ব্যবহৃত অর্থবোধক শব্দকে পদ বলা হয়। বিশেষ্য ব্যক্তি, বস্তু, স্থান বা ভাবের নাম বোঝায়। বিশেষ্যর পরিবর্তে ব্যবহৃত শব্দ সর্বনাম। বিশেষ্য বা সর্বনামের গুণ বোঝায় বিশেষণ। কাজ বা অবস্থা বোঝায় ক্রিয়া।', [
      QuizQuestion('“রাহিম বই পড়ে”—এখানে “রাহিম” কোন পদ?', ['ক্রিয়া', 'বিশেষ্য', 'বিশেষণ', 'সর্বনাম'], 1, 'রাহিম একজন ব্যক্তির নাম, তাই এটি বিশেষ্য।'),
      QuizQuestion('“সে” কোন পদ?', ['সর্বনাম', 'বিশেষ্য', 'ক্রিয়া', 'অব্যয়'], 0, 'বিশেষ্যের পরিবর্তে “সে” ব্যবহৃত হয়েছে, তাই সর্বনাম।'),
    ]),
  ],
  'English': [
    ChapterUnit('Parts of Speech', 'Noun, Pronoun, Verb and Adjective', 'Words have different jobs in a sentence. A noun names a person, place, animal or thing. A pronoun replaces a noun. A verb shows an action or state. An adjective describes a noun. Example: “Rina reads a beautiful book.” Rina and book are nouns, reads is a verb, and beautiful is an adjective.', [
      QuizQuestion('Which word is a verb in “Birds fly”?', ['Birds', 'Fly', 'The', 'Beautiful'], 1, 'Fly shows an action, so it is a verb.'),
      QuizQuestion('Which word is a pronoun?', ['Karim', 'School', 'They', 'Quickly'], 2, 'They is used instead of a noun, so it is a pronoun.'),
    ]),
    ChapterUnit('Tense: Present and Past', 'সময় অনুযায়ী verb-এর ব্যবহার', 'Tense tells us when an action happens. Simple present describes habits or facts: “I play football.” Simple past describes a completed past action: “I played football.” Some verbs are irregular: go becomes went.', [
      QuizQuestion('Choose the simple past of “go”.', ['Goed', 'Going', 'Went', 'Goes'], 2, 'The simple past form of go is went.'),
      QuizQuestion('“She reads every day” is in which tense?', ['Simple past', 'Simple present', 'Future', 'Present perfect'], 1, 'Reads describes a regular habit, so it is simple present.'),
    ]),
  ],
  'গণিত': [
    ChapterUnit('ভগ্নাংশ', 'লব, হর ও সমতুল ভগ্নাংশ', 'একটি সম্পূর্ণ বস্তুকে সমান কয়েকটি ভাগ করলে তার এক বা একাধিক ভাগকে ভগ্নাংশ দিয়ে প্রকাশ করা যায়। ভগ্নাংশে উপরের সংখ্যাটি লব এবং নিচের সংখ্যাটি হর। যেমন ৩/৪-এ লব ৩, হর ৪। লব ও হরকে একই শূন্য নয় এমন সংখ্যা দিয়ে গুণ করলে সমতুল ভগ্নাংশ পাওয়া যায়।', [
      QuizQuestion('৩/৪ ভগ্নাংশে হর কত?', ['৩', '৪', '৭', '১২'], 1, 'ভগ্নাংশের নিচের সংখ্যাটি হর; এখানে ৪।'),
      QuizQuestion('১/২-এর সমতুল ভগ্নাংশ কোনটি?', ['২/৩', '২/৪', '৩/৪', '১/৪'], 1, '১/২-এর লব ও হরকে ২ দিয়ে গুণ করলে ২/৪ হয়।'),
    ]),
    ChapterUnit('শতকরা', 'প্রতি একশতে হিসাব', 'শতকরা মানে প্রতি একশতে কত। কোনো সংখ্যার p% বের করতে সংখ্যাটিকে p দিয়ে গুণ করে ১০০ দিয়ে ভাগ করো। উদাহরণ: ২০০-এর ১০% = ২০০ × ১০ ÷ ১০০ = ২০।', [
      QuizQuestion('১০০-এর ২৫% কত?', ['১০', '২০', '২৫', '৫০'], 2, '১০০ × ২৫ ÷ ১০০ = ২৫।'),
      QuizQuestion('৮০-এর ৫০% কত?', ['২০', '৩০', '৪০', '৫০'], 2, '৫০% মানে অর্ধেক; ৮০-এর অর্ধেক ৪০।'),
    ]),
  ],
  'বিজ্ঞান': [
    ChapterUnit('উদ্ভিদের খাদ্য তৈরি', 'সালোকসংশ্লেষণ', 'সবুজ উদ্ভিদ সূর্যের আলো, পানি ও বাতাসের কার্বন ডাই-অক্সাইড ব্যবহার করে খাদ্য তৈরি করে। এই প্রক্রিয়ার নাম সালোকসংশ্লেষণ। পাতার ক্লোরোফিল সূর্যের আলো শোষণ করতে সাহায্য করে। এ সময় অক্সিজেনও নির্গত হয়।', [
      QuizQuestion('উদ্ভিদ খাদ্য তৈরি করে কোন প্রক্রিয়ায়?', ['শ্বসন', 'সালোকসংশ্লেষণ', 'পরিপাক', 'বাষ্পীভবন'], 1, 'উদ্ভিদ সালোকসংশ্লেষণের মাধ্যমে খাদ্য তৈরি করে।'),
      QuizQuestion('সালোকসংশ্লেষণে কোন গ্যাস ব্যবহৃত হয়?', ['অক্সিজেন', 'হাইড্রোজেন', 'কার্বন ডাই-অক্সাইড', 'নাইট্রোজেন'], 2, 'উদ্ভিদ বাতাস থেকে কার্বন ডাই-অক্সাইড গ্রহণ করে।'),
    ]),
    ChapterUnit('পদার্থের অবস্থা', 'কঠিন, তরল ও গ্যাস', 'পদার্থ সাধারণত কঠিন, তরল ও গ্যাসীয়—এই তিন অবস্থায় থাকতে পারে। কঠিনের নির্দিষ্ট আকার ও আয়তন থাকে। তরলের নির্দিষ্ট আয়তন থাকলেও পাত্রের আকার ধারণ করে। গ্যাস পাত্রের পুরো জায়গা দখল করে। পানি, বরফ ও জলীয় বাষ্প পরিচিত উদাহরণ।', [
      QuizQuestion('বরফ পদার্থের কোন অবস্থা?', ['কঠিন', 'তরল', 'গ্যাস', 'প্লাজমা'], 0, 'বরফের নির্দিষ্ট আকার আছে, তাই এটি কঠিন।'),
      QuizQuestion('জলীয় বাষ্প কোন অবস্থা?', ['কঠিন', 'তরল', 'গ্যাস', 'কোনোটিই নয়'], 2, 'জলীয় বাষ্প পানির গ্যাসীয় অবস্থা।'),
    ]),
  ],
};

class ChapterLibraryPage extends StatefulWidget {
  final int selectedClass;
  final String? initialSubject;
  const ChapterLibraryPage({super.key, required this.selectedClass, this.initialSubject});
  @override
  State<ChapterLibraryPage> createState() => _ChapterLibraryPageState();
}

class _ChapterLibraryPageState extends State<ChapterLibraryPage> {
  late int selectedClass;
  late String subject;
  @override
  void initState() {
    super.initState();
    selectedClass = widget.selectedClass;
    subject = widget.initialSubject ?? 'বাংলা';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('অধ্যায়ভিত্তিক লেসন', style: TextStyle(fontWeight: FontWeight.bold))),
    body: ListView(padding: const EdgeInsets.all(18), children: [
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF7660EA), Color(0xFF4E3CB8)]), borderRadius: BorderRadius.circular(18)), child: const Text('অধ্যায় বেছে নাও, লেসন পড়ো, তারপর MCQ দিয়ে নিজেকে যাচাই করো।', style: TextStyle(color: Colors.white, fontSize: 15, height: 1.5, fontWeight: FontWeight.w600))),
      const SizedBox(height: 18),
      const Text('শ্রেণি', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 7),
      DropdownButtonFormField<int>(
        value: selectedClass,
        decoration: const InputDecoration(filled: true, border: OutlineInputBorder()),
        items: List.generate(5, (i) => i + 6).map((c) => DropdownMenuItem(value: c, child: Text('Class $c'))).toList(),
        onChanged: (v) => setState(() => selectedClass = v ?? selectedClass),
      ),
      const SizedBox(height: 14),
      const Text('বিষয়', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 7),
      DropdownButtonFormField<String>(
        value: subject,
        decoration: const InputDecoration(filled: true, border: OutlineInputBorder()),
        items: chapterLibrary.keys.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: (v) => setState(() => subject = v ?? subject),
      ),
      const SizedBox(height: 18),
      Text('Class ' + selectedClass.toString() + ' • ' + subject, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: purple)),
      const SizedBox(height: 10),
      ...chapterLibrary[subject]!.asMap().entries.map((entry) {
        final i = entry.key;
        final unit = entry.value;
        return Card(elevation: 0, color: Colors.white, margin: const EdgeInsets.only(bottom: 11), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          leading: CircleAvatar(backgroundColor: pale, child: Text((i + 1).toString(), style: const TextStyle(color: purple, fontWeight: FontWeight.bold))),
          title: Text(unit.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(unit.summary + '\\n' + unit.questions.length.toString() + 'টি MCQ • লেসন + কুইজ', style: const TextStyle(height: 1.5)),
          isThreeLine: true,
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChapterDetailPage(classNumber: selectedClass, subject: subject, unit: unit))),
        ));
      }),
      const SizedBox(height: 8),
      const Text('নোট: এগুলো প্রাথমিক নমুনা লেসন। নির্দিষ্ট NCTB শ্রেণি/সংস্করণের হুবহু অধ্যায় নয়।', style: TextStyle(fontSize: 11, color: Colors.black54, height: 1.5)),
    ]),
  );
}

class ChapterDetailPage extends StatefulWidget {
  final int classNumber;
  final String subject;
  final ChapterUnit unit;
  const ChapterDetailPage({super.key, required this.classNumber, required this.subject, required this.unit});
  @override
  State<ChapterDetailPage> createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  int index = 0, score = 0;
  int? selected;
  bool completed = false, speaking = false;
  final FlutterTts lessonTts = FlutterTts();
  QuizQuestion get question => widget.unit.questions[index];

  @override
  void initState() {
    super.initState();
    _prepareLessonVoice();
  }

  Future<void> _prepareLessonVoice() async {
    try {
      await lessonTts.setLanguage(widget.subject == 'English' ? 'en-US' : 'bn-BD');
      await lessonTts.setSpeechRate(0.44);
      lessonTts.setCompletionHandler(() {
        if (mounted) setState(() => speaking = false);
      });
    } catch (_) {}
  }

  Future<void> _toggleLessonVoice() async {
    try {
      if (speaking) {
        await lessonTts.stop();
        if (mounted) setState(() => speaking = false);
      } else {
        await lessonTts.stop();
        if (mounted) setState(() => speaking = true);
        await lessonTts.speak(widget.unit.title + '. ' + widget.unit.lesson);
      }
    } catch (_) {
      if (mounted) setState(() => speaking = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('এই ডিভাইসে ভয়েস চালানো যাচ্ছে না।')));
    }
  }

  @override
  void dispose() {
    lessonTts.stop();
    super.dispose();
  }

  void next() {
    if (selected == null) return;
    setState(() {
      if (selected == question.answer) score++;
      if (index == widget.unit.questions.length - 1) {
        completed = true;
        StudyProgress.awardQuiz();
      } else {
        index++;
        selected = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.unit.title, style: const TextStyle(fontWeight: FontWeight.bold))),
    body: ListView(padding: const EdgeInsets.all(18), children: [
      Text('Class ' + widget.classNumber.toString() + ' • ' + widget.subject, style: const TextStyle(color: purple, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: Text('📘 লেসন', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: ink))),
          IconButton.filledTonal(
            onPressed: _toggleLessonVoice,
            tooltip: speaking ? 'পড়া বন্ধ করো' : 'লেসন শুনো',
            icon: Icon(speaking ? Icons.stop_rounded : Icons.volume_up_rounded),
          ),
        ]),
        const SizedBox(height: 12),
        Text(widget.unit.lesson, style: const TextStyle(fontSize: 16, height: 1.8, color: ink)),
      ])),
      const SizedBox(height: 18),
      const Text('📝 অধ্যায়ের MCQ', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: ink)),
      const SizedBox(height: 10),
      if (completed) Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(18)), child: Column(children: [
        const Icon(Icons.emoji_events_rounded, size: 52, color: Color(0xFFE6A23C)),
        const SizedBox(height: 8),
        const Text('কুইজ শেষ!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text('তোমার স্কোর: ' + score.toString() + ' / ' + widget.unit.questions.length.toString(), style: const TextStyle(fontSize: 19, color: purple, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        FilledButton.icon(onPressed: () => setState(() { index = 0; score = 0; selected = null; completed = false; }), icon: const Icon(Icons.refresh), label: const Text('আবার দাও')),
      ])) else ...[
        Text('প্রশ্ন ' + (index + 1).toString() + ' / ' + widget.unit.questions.length.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: purple)),
        const SizedBox(height: 8),
        Text(question.question, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, height: 1.5)),
        const SizedBox(height: 10),
        ...List.generate(question.options.length, (i) {
          final answered = selected != null;
          final correct = i == question.answer;
          return Container(margin: const EdgeInsets.only(bottom: 8), child: ListTile(
            tileColor: answered && correct ? const Color(0xFFE7F7EC) : selected == i ? const Color(0xFFFFEEEE) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13), side: BorderSide(color: answered && correct ? Colors.green : selected == i ? Colors.red : Colors.black12)),
            title: Text(question.options[i]),
            leading: CircleAvatar(radius: 14, backgroundColor: pale, child: Text(String.fromCharCode(65 + i), style: const TextStyle(color: purple))),
            trailing: answered && correct ? const Icon(Icons.check_circle, color: Colors.green) : null,
            onTap: answered ? null : () => setState(() => selected = i),
          ));
        }),
        if (selected != null) Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(13)), child: Text((selected == question.answer ? 'সঠিক উত্তর! ' : 'সঠিক উত্তর: ' + question.options[question.answer] + '. ') + question.explanation, style: const TextStyle(height: 1.5))),
        const SizedBox(height: 10),
        SizedBox(height: 48, child: FilledButton(onPressed: selected == null ? null : next, child: Text(index == widget.unit.questions.length - 1 ? 'ফলাফল দেখো' : 'পরের প্রশ্ন'))),
      ],
    ]),
  );
}



class StudyProgress {
  static Future<void> awardQuiz() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayKey = '${yesterday.year}-${yesterday.month}-${yesterday.day}';
    final lastDay = prefs.getString('progress_last_day') ?? '';
    var streak = prefs.getInt('progress_streak') ?? 0;
    if (lastDay != todayKey) {
      streak = lastDay == yesterdayKey ? streak + 1 : 1;
      await prefs.setString('progress_last_day', todayKey);
      await prefs.setInt('progress_streak', streak);
    }
    await prefs.setInt('progress_xp', (prefs.getInt('progress_xp') ?? 0) + 10);
    await prefs.setInt('progress_quizzes', (prefs.getInt('progress_quizzes') ?? 0) + 1);
  }

  static Future<Map<String, int>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'xp': prefs.getInt('progress_xp') ?? 0,
      'streak': prefs.getInt('progress_streak') ?? 0,
      'quizzes': prefs.getInt('progress_quizzes') ?? 0,
    };
  }
}

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('আমার অগ্রগতি', style: TextStyle(fontWeight: FontWeight.bold))),
    body: FutureBuilder<Map<String, int>>(
      future: StudyProgress.load(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {'xp': 0, 'streak': 0, 'quizzes': 0};
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        return ListView(padding: const EdgeInsets.all(18), children: [
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF7660EA), Color(0xFF4E3CB8)]), borderRadius: BorderRadius.circular(22)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('চালিয়ে যাও, তুমি পারবে!', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text("${data['xp']} XP", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
            const Text('কুইজ শেষ করলে ১০ XP পাবে', style: TextStyle(color: Colors.white70)),
          ])),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _ProgressStat(icon: Icons.local_fire_department_rounded, value: "${data['streak']}", label: 'দিনের Streak', color: Colors.deepOrange)),
            const SizedBox(width: 10),
            Expanded(child: _ProgressStat(icon: Icons.quiz_rounded, value: "${data['quizzes']}", label: 'কুইজ শেষ', color: purple)),
          ]),
          const SizedBox(height: 22),
          const Text('🏆 Leaderboard (ডেমো)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _rankRow('১', 'Study Star', '120 XP'),
          _rankRow('২', 'Quiz Master', '90 XP'),
          _rankRow('৩', 'তুমি', "${data['xp']} XP"),
          const SizedBox(height: 10),
          const Text('নোট: XP ও Streak এই ডিভাইসে সেভ হয়। Leaderboard আপাতত নমুনা; অন্য শিক্ষার্থীদের লাইভ র‍্যাঙ্ক দেখাতে অনলাইন ডাটাবেস ও অ্যাকাউন্ট লাগবে।', style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.5)),
        ]);
      },
    ),
  );

  static Widget _rankRow(String rank, String name, String xp) => Card(elevation: 0, color: Colors.white, child: ListTile(
    leading: CircleAvatar(backgroundColor: pale, child: Text(rank, style: const TextStyle(color: purple, fontWeight: FontWeight.bold))),
    title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
    trailing: Text(xp, style: const TextStyle(color: purple, fontWeight: FontWeight.bold)),
  ));
}

class _ProgressStat extends StatelessWidget {
  final IconData icon;
  final String value, label;
  final Color color;
  const _ProgressStat({required this.icon, required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)), child: Column(children: [
    Icon(icon, color: color, size: 28),
    const SizedBox(height: 6),
    Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: ink)),
    Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
  ]));
}


class SimplePage extends StatelessWidget {
  final String title, subtitle; final IconData icon;
  const SimplePage({super.key, required this.title, required this.subtitle, required this.icon});
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 82, height: 82, decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(25)), child: Icon(icon, size: 42, color: purple)),
    const SizedBox(height: 18), Text(title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: ink)),
    const SizedBox(height: 8), Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
  ])));
}


class StudyGuide {
  final String name, subject, intro;
  final IconData icon;
  final Color color;
  const StudyGuide(this.name, this.subject, this.intro, this.icon, this.color);
}

const guides = [
  StudyGuide('আরিফ', 'গণিত', 'ধাপে ধাপে অঙ্ক বুঝিয়ে দেব', Icons.calculate_rounded, Color(0xFF5B8DEF)),
  StudyGuide('সারা', 'English', 'Grammar ও vocabulary শেখাবে', Icons.menu_book_rounded, Color(0xFFB078E8)),
  StudyGuide('রায়ান', 'বিজ্ঞান', 'বিজ্ঞানের কঠিন বিষয় সহজ করবে', Icons.science_rounded, Color(0xFF36A889)),
  StudyGuide('মায়া', 'Study Mentor', 'রুটিন ও পড়ার পরিকল্পনায় সাহায্য করবে', Icons.auto_awesome_rounded, Color(0xFFE69A48)),
];

class BuddiesPage extends StatelessWidget {
  const BuddiesPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF8F8FC),
    appBar: AppBar(title: const Text('তোমার Study Buddies', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: const Color(0xFFF8F8FC)),
    body: ListView(padding: const EdgeInsets.all(18), children: [
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF7660EA), Color(0xFF4E3CB8)]), borderRadius: BorderRadius.circular(22)), child: const Text('পড়ায় আটকে গেলে তোমার গাইডের সঙ্গে কথা বলো!\nChat করো অথবা মাইক্রোফোনে প্রশ্ন বলো।', style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5, fontWeight: FontWeight.w600))),
      const SizedBox(height: 18),
      ...guides.map((g) => Card(elevation: 0, color: Colors.white, margin: const EdgeInsets.only(bottom: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: GuideAvatar(guide: g, size: 62),
        title: Text('${g.name} • ${g.subject}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(g.intro),
        trailing: IconButton(
          tooltip: 'Voice lesson',
          icon: const Icon(Icons.play_circle_fill_rounded, color: purple, size: 30),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VoiceLessonPage(guide: g))),
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GuideChatPage(guide: g))),
      ))),
      const Padding(padding: EdgeInsets.only(top: 4), child: Text('নোট: ভয়েস ফিচার ফোনের Speech ও Text-to-Speech সুবিধা ব্যবহার করে।', style: TextStyle(color: Colors.black54, fontSize: 11))),
    ]),
  );
}

class GuideAvatar extends StatefulWidget {
  final StudyGuide guide;
  final double size;
  const GuideAvatar({super.key, required this.guide, this.size = 76});
  @override
  State<GuideAvatar> createState() => _GuideAvatarState();
}

class _GuideAvatarState extends State<GuideAvatar> with SingleTickerProviderStateMixin {
  late final AnimationController _motion = AnimationController(vsync: this, duration: const Duration(milliseconds: 1900))..repeat(reverse: true);

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guide = widget.guide;
    final size = widget.size;
    return AnimatedBuilder(
      animation: _motion,
      builder: (context, child) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY((_motion.value - .5) * .12)
          ..translate(0.0, -3.0 * _motion.value, 0.0),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-.55, -.65),
              radius: 1.25,
              colors: [
                Color.lerp(guide.color, Colors.white, .62)!,
                guide.color,
                Color.lerp(guide.color, Colors.black, .22)!,
              ],
            ),
            borderRadius: BorderRadius.circular(size * .34),
            boxShadow: [
              BoxShadow(color: guide.color.withOpacity(.32), blurRadius: 16, offset: Offset(0, 7 + 2 * _motion.value)),
              const BoxShadow(color: Colors.white, blurRadius: 1, spreadRadius: 1),
            ],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Stack(alignment: Alignment.center, children: [
            Positioned(top: size * .07, left: size * .10, child: Container(width: size * .30, height: size * .12, decoration: BoxDecoration(color: Colors.white.withOpacity(.24), borderRadius: BorderRadius.circular(30)))),
            Icon(Icons.face_rounded, color: Colors.white.withOpacity(.98), size: size * .65, shadows: const [Shadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3))]),
            Positioned(bottom: size * .08, right: size * .08, child: Container(width: size * .19, height: size * .19, decoration: BoxDecoration(color: const Color(0xFF8EF0B0), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)]))),
          ]),
        ),
      ),
    );
  }
}

class GuideChatPage extends StatefulWidget {
  final StudyGuide guide;
  const GuideChatPage({super.key, required this.guide});
  @override
  State<GuideChatPage> createState() => _GuideChatPageState();
}

class _GuideChatPageState extends State<GuideChatPage> {
  final input = TextEditingController();
  final tts = FlutterTts();
  final speech = stt.SpeechToText();
  final messages = <Map<String, String>>[];
  bool listening = false, speechReady = false;

  @override
  void initState() {
    super.initState();
    messages.add({'from':'guide','text':'আসসালামু আলাইকুম! আমি ${widget.guide.name}, তোমার ${widget.guide.subject} গাইড। কী শিখতে চাও?'});
    _setupVoice();
  }

  Future<void> _setupVoice() async {
    try {
      speechReady = await speech.initialize();
      await tts.setLanguage('bn-BD');
      await tts.setSpeechRate(0.48);
      if (mounted) setState(() {});
    } catch (_) {}
  }

  String _answer(String q) {
    final text = q.toLowerCase();
    if (text.contains('হ্যালো') || text.contains('hello') || text.contains('সালাম')) return 'ওয়ালাইকুম আসসালাম! আজ কোন বিষয়টি শিখব?';
    if (text.contains('গণিত') || text.contains('math') || text.contains('অঙ্ক')) return 'চলো ধাপে ধাপে করি। প্রথমে প্রশ্নে কী দেওয়া আছে আর কী বের করতে বলেছে, সেটা লিখে ফেলো। পুরো প্রশ্নটি পাঠাও, আমি বুঝিয়ে দেব।';
    if (text.contains('english') || text.contains('grammar') || text.contains('ইংরেজি')) return 'চমৎকার! একটি ছোট বাক্য লেখো। আমরা Grammar, শব্দের অর্থ এবং উদাহরণ দিয়ে শিখব।';
    if (text.contains('বিজ্ঞান') || text.contains('science')) return 'বিজ্ঞান বুঝতে বাস্তব উদাহরণ সবচেয়ে ভালো। কোন অধ্যায় বা ধারণাটি বুঝতে অসুবিধা হচ্ছে?';
    if (text.contains('রুটিন') || text.contains('পড়ব') || text.contains('routine')) return 'আজ ২৫ মিনিটের একটি ছোট লক্ষ্য নাও, তারপর ৫ মিনিট বিরতি। কোন কোন বিষয় পড়তে হবে বলো, তোমার জন্য রুটিন সাজাই।';
    return 'ভালো প্রশ্ন! আরেকটু বিস্তারিত লিখে দাও বা বইয়ের প্রশ্নটি পাঠাও। আমি সহজ ভাষায় ধাপে ধাপে বুঝিয়ে দেওয়ার চেষ্টা করব।';
  }

  Future<void> _send([String? value]) async {
    final q = (value ?? input.text).trim();
    if (q.isEmpty) return;
    input.clear();
    final a = _answer(q);
    setState(() { messages.add({'from':'user','text':q}); messages.add({'from':'guide','text':a}); });
    try { await tts.stop(); await tts.speak(a); } catch (_) {}
  }

  Future<void> _listen() async {
    if (!speechReady) { await _setupVoice(); }
    if (!speechReady) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('এই ফোনে Speech Recognition চালু করা যায়নি।')));
      return;
    }
    if (listening) { await speech.stop(); setState(() => listening = false); return; }
    setState(() => listening = true);
    await speech.listen(localeId: 'bn_BD', onResult: (result) {
      input.text = result.recognizedWords;
      if (result.finalResult && mounted) setState(() {});
    });
  }

  @override
  void dispose() { input.dispose(); speech.stop(); tts.stop(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Row(children: [GuideAvatar(guide: widget.guide, size: 38), const SizedBox(width: 10), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.guide.name, style: const TextStyle(fontWeight: FontWeight.bold)), Text('${widget.guide.subject} Guide', style: const TextStyle(fontSize: 11, color: Colors.black54))]) ])),
    body: Column(children: [
      Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: messages.length, itemBuilder: (context, i) {
        final m = messages[i]; final mine = m['from'] == 'user';
        return Align(alignment: mine ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(13), constraints: const BoxConstraints(maxWidth: 310), decoration: BoxDecoration(color: mine ? const Color(0xFFECE8FF) : Colors.white, borderRadius: BorderRadius.circular(16)), child: Text(m['text']!)));
      })),
      SafeArea(top: false, child: Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 12), child: Row(children: [
        IconButton.filledTonal(onPressed: _listen, icon: Icon(listening ? Icons.stop : Icons.mic), tooltip: 'কথা বলো'),
        const SizedBox(width: 8),
        Expanded(child: TextField(controller: input, textInputAction: TextInputAction.send, onSubmitted: (_) => _send(), decoration: InputDecoration(hintText: 'প্রশ্ন লিখো...', filled: true, fillColor: const Color(0xFFF3F1FA), border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)))),
        const SizedBox(width: 8),
        IconButton.filled(onPressed: () => _send(), icon: const Icon(Icons.send_rounded)),
      ]))),
    ]),
  );
}


class VoiceLessonPage extends StatefulWidget {
  final StudyGuide guide;
  const VoiceLessonPage({super.key, required this.guide});
  @override
  State<VoiceLessonPage> createState() => _VoiceLessonPageState();
}

class _VoiceLessonPageState extends State<VoiceLessonPage> {
  final FlutterTts tts = FlutterTts();
  final stt.SpeechToText speech = stt.SpeechToText();
  int lessonIndex = 0;
  bool speaking = false;
  bool listening = false;
  bool speechReady = false;
  String heard = '';

  List<Map<String, String>> get lessons {
    switch (widget.guide.subject) {
      case 'গণিত':
        return [
          {'title': 'গুণের সহজ ধারণা', 'body': 'গুণ হলো একই সংখ্যাকে বারবার যোগ করার সংক্ষিপ্ত পদ্ধতি। যেমন, ৩ গুণ ৪ মানে ৩ চারবার যোগ: ৩ যোগ ৩ যোগ ৩ যোগ ৩, যার ফল ১২।'},
          {'title': 'ভগ্নাংশ পরিচিতি', 'body': 'ভগ্নাংশ কোনো সম্পূর্ণ বস্তুর সমান অংশের এক বা একাধিক অংশ বোঝায়। উপরের সংখ্যাকে লব এবং নিচের সংখ্যাকে হর বলে।'},
          {'title': 'শতকরা', 'body': 'শতকরা মানে প্রতি একশতে কত। ৫০ শতাংশ মানে একশ ভাগের পঞ্চাশ ভাগ, অর্থাৎ অর্ধেক।'},
        ];
      case 'English':
        return [
          {'title': 'Noun', 'body': 'A noun is the name of a person, place, animal, or thing. Examples are Rina, Dhaka, cat, and book. Repeat: A noun names something.'},
          {'title': 'Verb', 'body': 'A verb expresses an action or a state. Examples are read, play, write, and is. In the sentence I read a book, read is the verb.'},
          {'title': 'Adjective', 'body': 'An adjective describes a noun. Examples are a beautiful flower, a tall tree, and a kind person.'},
        ];
      case 'বিজ্ঞান':
        return [
          {'title': 'সালোকসংশ্লেষণ', 'body': 'সবুজ উদ্ভিদ সূর্যের আলো, পানি ও কার্বন ডাই অক্সাইড ব্যবহার করে নিজের খাদ্য তৈরি করে। এই প্রক্রিয়াকে সালোকসংশ্লেষণ বলে।'},
          {'title': 'পানির অবস্থা', 'body': 'পানি কঠিন, তরল ও গ্যাসীয়—এই তিন অবস্থায় থাকতে পারে। বরফ হলো কঠিন, সাধারণ পানি তরল, আর জলীয় বাষ্প গ্যাসীয় অবস্থা।'},
          {'title': 'বল', 'body': 'কোনো বস্তুকে ধাক্কা দেওয়া বা টানাকে বল বলে। বল বস্তুর গতি, দিক বা আকৃতি পরিবর্তন করতে পারে।'},
        ];
      default:
        return [
          {'title': 'ভালোভাবে পড়ার কৌশল', 'body': 'একবারে অল্প পড়ো, নিজের ভাষায় বোঝানোর চেষ্টা করো, তারপর বই বন্ধ করে মনে করার অনুশীলন করো। নিয়মিত ছোট বিরতি নিলে মনোযোগ ধরে রাখা সহজ হয়।'},
          {'title': 'নতুন শব্দ শেখা', 'body': 'প্রতিদিন কয়েকটি নতুন শব্দ শেখো। শব্দের অর্থ, একটি বাক্য এবং উচ্চারণ একসঙ্গে অনুশীলন করো।'},
          {'title': 'পুনরাবৃত্তি', 'body': 'আজ যা শিখেছ, দিনের শেষে একবার ঝালিয়ে নাও। পরের দিন আবার মনে করার চেষ্টা করো। এতে শেখা দীর্ঘস্থায়ী হয়।'},
        ];
    }
  }

  Map<String, String> get current => lessons[lessonIndex];

  @override
  void initState() {
    super.initState();
    _prepareVoice();
  }

  Future<void> _prepareVoice() async {
    try {
      speechReady = await speech.initialize();
      await tts.setLanguage(widget.guide.subject == 'English' ? 'en-US' : 'bn-BD');
      await tts.setSpeechRate(0.43);
      tts.setCompletionHandler(() {
        if (mounted) setState(() => speaking = false);
      });
      if (mounted) setState(() {});
    } catch (_) {}
  }

  Future<void> _play() async {
    try {
      await tts.stop();
      setState(() => speaking = true);
      await tts.speak('${current['title']}. ${current['body']}');
    } catch (_) {
      if (mounted) setState(() => speaking = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('এই ব্রাউজারে ভয়েস চালু করা যায়নি।')));
    }
  }

  Future<void> _stop() async {
    await tts.stop();
    if (mounted) setState(() => speaking = false);
  }

  Future<void> _listen() async {
    if (!speechReady) await _prepareVoice();
    if (!speechReady) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('মাইক্রোফোন বা Speech Recognition অনুমতি পাওয়া যায়নি।')));
      return;
    }
    if (listening) {
      await speech.stop();
      if (mounted) setState(() => listening = false);
      return;
    }
    setState(() { listening = true; heard = ''; });
    await speech.listen(
      localeId: widget.guide.subject == 'English' ? 'en_US' : 'bn_BD',
      onResult: (result) {
        if (!mounted) return;
        setState(() {
          heard = result.recognizedWords;
          if (result.finalResult) listening = false;
        });
      },
    );
  }

  @override
  void dispose() {
    tts.stop();
    speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('ভয়েস লেসন', style: TextStyle(fontWeight: FontWeight.bold))),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Center(child: GuideAvatar(guide: widget.guide, size: 112)),
      const SizedBox(height: 12),
      Center(child: Text('${widget.guide.name} • ${widget.guide.subject}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ink))),
      const SizedBox(height: 5),
      const Center(child: Text('শোনো, বোঝো, তারপর নিজে বলো', style: TextStyle(color: Colors.black54))),
      const SizedBox(height: 22),
      LinearProgressIndicator(value: (lessonIndex + 1) / lessons.length, color: purple, backgroundColor: pale, minHeight: 7),
      const SizedBox(height: 9),
      Text('লেসন ${lessonIndex + 1} / ${lessons.length}', style: const TextStyle(color: purple, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(current['title']!, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: ink)),
        const SizedBox(height: 12),
        Text(current['body']!, style: const TextStyle(fontSize: 17, height: 1.7, color: ink)),
      ])),
      const SizedBox(height: 16),
      FilledButton.icon(onPressed: speaking ? _stop : _play, icon: Icon(speaking ? Icons.stop_circle_outlined : Icons.volume_up_rounded), label: Text(speaking ? 'শোনা বন্ধ করো' : 'গাইডের কথা শোনো')),
      const SizedBox(height: 10),
      OutlinedButton.icon(onPressed: _listen, icon: Icon(listening ? Icons.stop : Icons.mic), label: Text(listening ? 'শোনা হচ্ছে… থামাও' : 'এবার নিজে বলে দেখো')),
      if (heard.isNotEmpty) Container(margin: const EdgeInsets.only(top: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(14)), child: Text('তুমি বলেছ: $heard')),
      const SizedBox(height: 18),
      Row(children: [
        Expanded(child: OutlinedButton(onPressed: lessonIndex == 0 ? null : () { setState(() { lessonIndex--; heard = ''; }); _stop(); }, child: const Text('আগের লেসন'))),
        const SizedBox(width: 10),
        Expanded(child: FilledButton(onPressed: lessonIndex == lessons.length - 1 ? null : () { setState(() { lessonIndex++; heard = ''; }); _stop(); }, child: const Text('পরের লেসন'))),
      ]),
      const SizedBox(height: 12),
      const Text('এগুলো নমুনা অনুশীলনী লেসন; নির্দিষ্ট NCTB বইয়ের অধ্যায়ের হুবহু পাঠ নয়। ভয়েস কাজ করতে ব্রাউজারের মাইক্রোফোন অনুমতি লাগতে পারে।', style: TextStyle(fontSize: 11, color: Colors.black54, height: 1.5)),
    ]),
  );
}
