import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() => runApp(const StudyMateApp());

const ink = Color(0xFF17152B);
const purple = Color(0xFF7057E8);
const pale = Color(0xFFF4F1FF);

class StudyMateApp extends StatelessWidget {
  const StudyMateApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'StudyMate',
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: const Color(0xFFF8F8FC), colorScheme: ColorScheme.fromSeed(seedColor: purple)),
    home: const HomePage(),
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

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: IndexedStack(index: tab, children: [_home(), const BuddiesPage(), PracticePage(selectedClass: selectedClass), const SimplePage(title: 'নোটস', subtitle: 'তোমার পড়ার নোট এখানে সাজানো থাকবে।', icon: Icons.menu_book_outlined), const SimplePage(title: 'প্রোফাইল', subtitle: 'তোমার শেখার অগ্রগতি এখানে দেখা যাবে।', icon: Icons.person_outline)])),
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
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('StudyMate', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: ink)), Text('শেখা হোক আরও সহজ', style: TextStyle(color: Colors.black54, fontSize: 12))])),
      IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
    ]),
    const SizedBox(height: 24),
    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF7660EA), Color(0xFF4E3CB8)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('আজ থেকেই শুরু হোক!', style: TextStyle(color: Colors.white70, fontSize: 13)), SizedBox(height: 8),
      Text('প্রতিদিন একটু একটু\nকরে এগিয়ে যাও।', style: TextStyle(color: Colors.white, fontSize: 23, height: 1.3, fontWeight: FontWeight.bold)),
      SizedBox(height: 15), Row(children: [Icon(Icons.auto_awesome, color: Colors.white, size: 17), SizedBox(width: 7), Text('তোমার পড়াশোনার সঙ্গী', style: TextStyle(color: Colors.white, fontSize: 12))]),
    ])),
    const SizedBox(height: 26),
    const Text('তোমার শ্রেণি নির্বাচন করো', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: ink)),
    const SizedBox(height: 12),
    Wrap(spacing: 9, runSpacing: 9, children: List.generate(5, (i) { final c = i + 6; final active = selectedClass == c; return ChoiceChip(label: Text('Class $c'), selected: active, onSelected: (_) => setState(() => selectedClass = c), selectedColor: pale, labelStyle: TextStyle(color: active ? purple : ink, fontWeight: FontWeight.w700), side: BorderSide(color: active ? purple : Colors.black12)); })),
    const SizedBox(height: 25),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('বিষয়সমূহ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: ink)), Text('Class $selectedClass', style: const TextStyle(color: purple, fontWeight: FontWeight.w700))]),
    const SizedBox(height: 12),
    GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.65, children: [
      SubjectTile(title: 'বাংলা', subtitle: 'ভাষা ও সাহিত্য', icon: Icons.translate, color: Color(0xFFEFF7F1), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PracticePage(selectedClass: selectedClass, initialSubject: 'বাংলা')))),
      SubjectTile(title: 'English', subtitle: 'Grammar & Reading', icon: Icons.language, color: Color(0xFFEEF3FF), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PracticePage(selectedClass: selectedClass, initialSubject: 'English')))),
      SubjectTile(title: 'গণিত', subtitle: 'অনুশীলন ও সমাধান', icon: Icons.calculate_outlined, color: Color(0xFFFFF4E8), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PracticePage(selectedClass: selectedClass, initialSubject: 'গণিত')))),
      SubjectTile(title: 'বিজ্ঞান', subtitle: 'ধারণা ও আবিষ্কার', icon: Icons.science_outlined, color: Color(0xFFF4EEFF), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PracticePage(selectedClass: selectedClass, initialSubject: 'বিজ্ঞান')))),
    ]),
    const SizedBox(height: 22),
    const Text('দ্রুত শুরু করো', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: ink)),
    const SizedBox(height: 12),
    _quick(Icons.play_circle_outline, 'MCQ Quiz', 'নিজেকে যাচাই করো', () => setState(() => tab = 2)),
    _quick(Icons.note_alt_outlined, 'আমার নোটস', 'গুরুত্বপূর্ণ বিষয় গুছিয়ে রাখো', () => setState(() => tab = 3)),
  ]);

  Widget _quick(IconData icon, String title, String subtitle, VoidCallback action) => Card(elevation: 0, color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), child: ListTile(onTap: action, leading: CircleAvatar(backgroundColor: pale, child: Icon(icon, color: purple)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(subtitle), trailing: const Icon(Icons.arrow_forward_ios, size: 15)));
}

class SubjectTile extends StatelessWidget {
  final String title, subtitle; final IconData icon; final Color color; final VoidCallback onTap;
  const SubjectTile({super.key, required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(17), child: Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: Colors.black.withOpacity(.04))), child: Row(children: [
    Container(width: 39, height: 39, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: ink)), const SizedBox(width: 10),
    Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: ink)), const SizedBox(height: 3), Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.black54))])),
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

  List<QuizQuestion> get questions => quizQuestions[subject]!;
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
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GuideChatPage(guide: g))),
      ))),
      const Padding(padding: EdgeInsets.only(top: 4), child: Text('নোট: ভয়েস ফিচার ফোনের Speech ও Text-to-Speech সুবিধা ব্যবহার করে।', style: TextStyle(color: Colors.black54, fontSize: 11))),
    ]),
  );
}

class GuideAvatar extends StatelessWidget {
  final StudyGuide guide; final double size;
  const GuideAvatar({super.key, required this.guide, this.size = 76});
  @override
  Widget build(BuildContext context) => Container(width: size, height: size, decoration: BoxDecoration(
    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [guide.color.withOpacity(.65), guide.color]),
    borderRadius: BorderRadius.circular(size * .34),
    boxShadow: [BoxShadow(color: guide.color.withOpacity(.25), blurRadius: 12, offset: const Offset(0, 5))],
    border: Border.all(color: Colors.white, width: 2),
  ), child: Stack(alignment: Alignment.center, children: [
    Icon(Icons.face_rounded, color: Colors.white.withOpacity(.96), size: size * .62),
    Positioned(bottom: size * .08, right: size * .08, child: Container(width: size * .19, height: size * .19, decoration: BoxDecoration(color: const Color(0xFF8EF0B0), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
  ]));
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
