import 'package:flutter/material.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/utils/app_assets.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'package:movies_app/core/utils/app_styles.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/features/auth/presentation/pages/login/login_view.dart';
import 'package:movies_app/features/profile_screen/presentation/profile_screen.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String userName = 'John Safwat';
  String userPhone = '01200000000';
  int selectedAvatarIndex = 0;

  final List<dynamic> watchList = [];
  final List<dynamic> historyList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await sl<AuthRepository>().signOut();
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginView()),
              (route) => false,
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // هيدر الملف الشخصي: الأفاتار، الاسم، وأرقام العدادات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage(AppAssets.avatars[selectedAvatarIndex]),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userName,
                        style: AppStyles.description.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _buildStat(watchList.length.toString(), 'Wish List'),
                  const SizedBox(width: 32),
                  _buildStat(historyList.length.toString(), 'History'),
                  const SizedBox(width: 10),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // أزرار Edit Profile و Exit
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                currentName: userName,
                                currentPhone: userPhone,
                                currentAvatarIndex: selectedAvatarIndex,
                              ),
                            ),
                          );

                          if (result != null && result is Map<String, dynamic>) {
                            setState(() {
                              userName = result['name'] ?? userName;
                              userPhone = result['phone'] ?? userPhone;
                              selectedAvatarIndex = result['avatarIndex'] ?? selectedAvatarIndex;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: AppStyles.buttonText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => _logout(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.delete,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Exit',
                              style: AppStyles.buttonText.copyWith(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.exit_to_app,
                              color: AppColors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // شريط التبويبات (Tabs)
            TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.white,
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(
                  icon: Icon(Icons.format_list_bulleted, size: 24),
                  text: 'Watch List',
                ),
                Tab(
                  icon: Icon(Icons.folder, size: 24),
                  text: 'History',
                ),
              ],
            ),

            // محتوى الـ Tabs
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGrid(
                    watchList,
                    'assets/images/watch list.png',
                  ),
                  _buildGrid(
                    historyList,
                    'assets/images/empty_list.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: AppStyles.title.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppStyles.description.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(List<dynamic> movies, String emptyImagePath) {
    if (movies.isEmpty) {
      return Center(
        child: SizedBox(
          width: 124,
          height: 124,
          child: Image.asset(
            emptyImagePath,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
              Icons.local_movies_outlined,
              size: 80,
              color: AppColors.grey,
            ),
          ),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                movie.posterUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: AppColors.textfield),
              ),
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Text(
                        movie.rating.toString(),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.star, color: AppColors.primary, size: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}