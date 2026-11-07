import 'package:flutter/material.dart';

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
    body: SafeArea(child: IndexedStack(index: tab, children: [_home(), const SimplePage(title: 'প্র্যাকটিস', subtitle: 'প্রশ্ন অনুশীলন খুব শিগগিরই আসছে।', icon: Icons.quiz_outlined), const SimplePage(title: 'নোটস', subtitle: 'তোমার পড়ার নোট এখানে সাজানো থাকবে।', icon: Icons.menu_book_outlined), const SimplePage(title: 'প্রোফাইল', subtitle: 'তোমার শেখার অগ্রগতি এখানে দেখা যাবে।', icon: Icons.person_outline)])),
    bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (v) => setState(() => tab = v), destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'হোম'),
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
