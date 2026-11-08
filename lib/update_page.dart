import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});
  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  bool loading = false;
  String? error, latestVersion, releaseUrl, checksum;
  int? latestBuild;
  int currentBuild = 0;

  @override
  void initState() { super.initState(); _check(); }

  Future<void> _check() async {
    setState(() { loading = true; error = null; });
    try {
      final info = await PackageInfo.fromPlatform();
      currentBuild = int.tryParse(info.buildNumber) ?? 0;
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/saifsafoanah-rgb/Study-Mate/releases?per_page=20'),
        headers: const {'Accept': 'application/vnd.github+json', 'X-GitHub-Api-Version': '2022-11-28'},
      ).timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) {
        throw Exception('GitHub থেকে আপডেটের তথ্য পাওয়া যায়নি (${response.statusCode})');
      }
      final releases = jsonDecode(response.body) as List<dynamic>;
      Map<String, dynamic>? latest;
      for (final item in releases) {
        final release = item as Map<String, dynamic>;
        final tag = (release['tag_name'] ?? '').toString();
        if (tag.startsWith('apk-') && release['draft'] != true) { latest = release; break; }
      }
      if (latest == null) throw Exception('এখনো কোনো APK release পাওয়া যায়নি।');
      final tag = latest['tag_name'].toString();
      final build = int.tryParse(tag.replaceFirst('apk-', ''));
      final assets = (latest['assets'] as List<dynamic>? ?? []);
      String? hash;
      for (final item in assets) {
        final asset = item as Map<String, dynamic>;
        if (asset['name'] == 'app-release.apk.sha256' && asset['browser_download_url'] != null) {
          final hashResponse = await http.get(Uri.parse(asset['browser_download_url'].toString())).timeout(const Duration(seconds: 15));
          if (hashResponse.statusCode == 200) hash = hashResponse.body.trim().split(RegExp(r'\\s+')).first;
        }
      }
      if (!mounted) return;
      setState(() {
        latestBuild = build;
        latestVersion = tag;
        releaseUrl = latest['html_url']?.toString();
        checksum = hash;
      });
    } catch (e) {
      if (mounted) setState(() => error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _openRelease() async {
    final url = releaseUrl;
    if (url == null) return;
    final uri = Uri.tryParse(url);
    if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final updateAvailable = latestBuild != null && latestBuild! > currentBuild;
    return Scaffold(
      appBar: AppBar(title: const Text('নিরাপদ আপডেট')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const Icon(Icons.verified_user_outlined, size: 64, color: Color(0xFF7057E8)),
        const SizedBox(height: 12),
        const Center(child: Text('StudyMate Update', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold))),
        const SizedBox(height: 8),
        Center(child: Text('ইনস্টল করা build: $currentBuild')),
        const SizedBox(height: 22),
        if (loading) const Center(child: CircularProgressIndicator()),
        if (error != null) ...[
          Text(error!, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton.icon(onPressed: _check, icon: const Icon(Icons.refresh), label: const Text('আবার চেষ্টা করো')),
        ],
        if (!loading && error == null && latestBuild != null) ...[
          Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(updateAvailable ? 'নতুন আপডেট পাওয়া গেছে' : 'তুমি সর্বশেষ build ব্যবহার করছো', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('সর্বশেষ release: $latestVersion'),
            if (checksum != null) ...[
              const SizedBox(height: 14),
              const Text('APK SHA-256', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              SelectableText(checksum!, style: const TextStyle(fontSize: 11)),
            ] else
              const Padding(padding: EdgeInsets.only(top: 10), child: Text('এই release-এর checksum পাওয়া যায়নি।', style: TextStyle(color: Colors.deepOrange))),
          ]))),
          const SizedBox(height: 14),
          if (updateAvailable)
            FilledButton.icon(onPressed: _openRelease, icon: const Icon(Icons.download), label: const Text('অফিশিয়াল GitHub থেকে APK নাও'))
          else
            OutlinedButton.icon(onPressed: _check, icon: const Icon(Icons.refresh), label: const Text('আবার চেক করো')),
        ],
        const SizedBox(height: 20),
        const Text('নিরাপত্তা: আপডেটের লিংক StudyMate-এর অফিসিয়াল GitHub release থেকে আসে। APK-এর SHA-256 এখানে দেখানো হয়, যাতে ডাউনলোড করা ফাইলের hash মিলিয়ে দেখা যায়। Android ইনস্টল করার আগে তোমার অনুমতি চাইবে।', style: TextStyle(fontSize: 12, height: 1.6, color: Colors.black54)),
      ]),
    );
  }
}
