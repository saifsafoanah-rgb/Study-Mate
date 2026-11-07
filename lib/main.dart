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
    body: SafeArea(child: IndexedStack(index: tab, children: [_home(), const BuddiesPage(), const SimplePage(title: 'প্র্যাকটিস', subtitle: 'প্রশ্ন অনুশীলন খুব শিগগিরই আসছে।', icon: Icons.quiz_outlined), const SimplePage(title: 'নোটস', subtitle: 'তোমার পড়ার নোট এখানে সাজানো থাকবে।', icon: Icons.menu_book_outlined), const SimplePage(title: 'প্রোফাইল', subtitle: 'তোমার শেখার অগ্রগতি এখানে দেখা যাবে।', icon: Icons.person_outline)])),
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
    GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.65, children: const [
      SubjectTile(title: 'বাংলা', subtitle: 'ভাষা ও সাহিত্য', icon: Icons.translate, color: Color(0xFFEFF7F1)),
      SubjectTile(title: 'English', subtitle: 'Grammar & Reading', icon: Icons.language, color: Color(0xFFEEF3FF)),
      SubjectTile(title: 'গণিত', subtitle: 'অনুশীলন ও সমাধান', icon: Icons.calculate_outlined, color: Color(0xFFFFF4E8)),
      SubjectTile(title: 'বিজ্ঞান', subtitle: 'ধারণা ও আবিষ্কার', icon: Icons.science_outlined, color: Color(0xFFF4EEFF)),
    ]),
    const SizedBox(height: 22),
    const Text('দ্রুত শুরু করো', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: ink)),
    const SizedBox(height: 12),
    _quick(Icons.play_circle_outline, 'MCQ Quiz', 'নিজেকে যাচাই করো', () => setState(() => tab = 1)),
    _quick(Icons.note_alt_outlined, 'আমার নোটস', 'গুরুত্বপূর্ণ বিষয় গুছিয়ে রাখো', () => setState(() => tab = 2)),
  ]);

  Widget _quick(IconData icon, String title, String subtitle, VoidCallback action) => Card(elevation: 0, color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), child: ListTile(onTap: action, leading: CircleAvatar(backgroundColor: pale, child: Icon(icon, color: purple)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(subtitle), trailing: const Icon(Icons.arrow_forward_ios, size: 15)));
}

class SubjectTile extends StatelessWidget {
  final String title, subtitle; final IconData icon; final Color color;
  const SubjectTile({super.key, required this.title, required this.subtitle, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: Colors.black.withOpacity(.04))), child: Row(children: [
    Container(width: 39, height: 39, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: ink)), const SizedBox(width: 10),
    Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: ink)), const SizedBox(height: 3), Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.black54))])),
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
