import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../styles/app_styles.dart';
import '../controller/game_controller.dart';
import '../model/score_entry.dart';

// --- LEADERBOARD DIALOG ---
class LeaderboardDialogBox extends StatefulWidget {
  const LeaderboardDialogBox({super.key});

  @override
  State<LeaderboardDialogBox> createState() => _LeaderboardDialogBoxState();
}

class _LeaderboardDialogBoxState extends State<LeaderboardDialogBox> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kDialogBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Text('Leaderboard', style: GoogleFonts.roboto(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                TabBar(
                  controller: tabController,
                  indicatorColor: const Color(0xFFB096F7),
                  labelColor: const Color(0xFFB096F7),
                  unselectedLabelColor: Colors.grey,
                  tabs: const [Tab(text: 'Shuffle'), Tab(text: 'Paragraphs')],
                ),
                const Divider(color: Colors.white, thickness: 1, indent: 25, endIndent: 25),
                SizedBox(
                  height: 400,
                  width: double.maxFinite,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      _buildScoreList('Shuffle'),
                      _buildScoreList('Paragraphs'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0, right: 0,
            child: _closeButton(context),
          )
        ],
      ),
    );
  }

  Widget _buildScoreList(String mode) {
    return FutureBuilder<List<ScoreEntry>>(
      future: Provider.of<GameController>(context, listen: false).getLeaderboard(mode),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        var list = snapshot.data!;
        if (list.isEmpty) return const Center(child: Text("No scores yet", style: TextStyle(color: Colors.white)));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFF333970), borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${index + 1}. ${list[index].username}", style: kLeaderboardTextStyle),
                  Text("${list[index].wpm} WPM", style: kLeaderboardTextStyle.copyWith(color: kPrimaryCyan)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// --- CREDITS DIALOG ---
class CreditsDialogBox extends StatelessWidget {
  const CreditsDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: kDialogBg, borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Text('Credits', style: GoogleFonts.roboto(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('MADE WITH LOVE BY:', style: GoogleFonts.roboto(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                const Divider(color: Colors.grey, indent: 25, endIndent: 25),
                const SizedBox(height: 24),
                _creditBtn('Dwayne Manuel', 'https://github.com/mirajwu'),
                const SizedBox(height: 16),
                _creditBtn('Matt Canarejo', 'https://github.com/mattcanarejo001-svg'),
                const SizedBox(height: 16),
                _creditBtn('Cristian Gannaban', 'https://github.com/crstntaro'),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Positioned(top: 0, right: 0, child: _closeButton(context))
        ],
      ),
    );
  }

  Widget _creditBtn(String name, String url) {
    return SizedBox(
      width: 250, height: 60,
      child: ElevatedButton(
        onPressed: () async {
          final Uri uri = Uri.parse(url);
          // FIX: Launch directly with externalApplication mode to ensure it opens in the browser.
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            debugPrint("Could not launch $url");
          }
        },
        style: kCreditButtonStyle,
        child: Text(name),
      ),
    );
  }
}

Widget _closeButton(BuildContext context) {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
        shape: const CircleBorder(), backgroundColor: const Color(0xFFAF3D3D), padding: const EdgeInsets.all(8)),
    onPressed: () => Navigator.of(context).pop(),
    child: Image.asset('assets/exit.png', width: 20, height: 20),
  );
}