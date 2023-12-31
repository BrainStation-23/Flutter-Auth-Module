import 'dart:convert';

import 'package:auth_module/src/core/services/routes/routes.dart';
import 'package:auth_module/src/core/services/local_storage/cache_service.dart';
import 'package:auth_module/src/core/theme/typography/style.dart';
import 'package:auth_module/src/core/utils/text_constants.dart';
import 'package:auth_module/src/core/theme/theme.dart';
import 'package:auth_module/src/core/widgets/avatar.dart';
import 'package:auth_module/src/core/widgets/name_with_letter.dart';
import 'package:auth_module/src/core/widgets/primary_snackbar.dart';
import 'package:auth_module/src/features/authentication/log_out/presentation/riverpod/log_out_providers.dart';
import 'package:auth_module/src/features/authentication/root/presentation/riverpod/mock_user/mock_user_provider.dart';
import 'package:auth_module/src/features/authentication/sign_in/presentation/riverpod/sign_in_providers.dart';
import 'package:auth_module/src/features/profile/update_profile/presentation/riverpod/update_profile_info_provider.dart';
import 'package:auth_module/src/features/profile/update_profile/presentation/riverpod/update_profile_state.dart';
import 'package:auth_module/src/features/profile/user_profile/presentation/riverpod/user_profile_info_provider.dart';
import 'package:auth_module/src/features/profile/user_profile/presentation/riverpod/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part '../widget/drawer_header_widget.dart';

class DrawerBuilder extends ConsumerStatefulWidget {
  const DrawerBuilder({super.key});

  @override
  ConsumerState<DrawerBuilder> createState() => _DrawerBuilderState();
}

class _DrawerBuilderState extends ConsumerState<DrawerBuilder> {
  @override
  Widget build(BuildContext context) {
    final logOutState = ref.watch(logOutProvider);
    final logOutNotifier = ref.read(logOutProvider.notifier);

    final profileState = ref.watch(userProfileInfoProvider);
    final updateState = ref.watch(updateProfileInfoProvider);

    bool offlineState = ref.read(offlineStateProvider);

    ref.listen(logOutProvider, (previous, next) {
      if (next.status == LogOutStatus.success) {
        _logoutAndNavigateToSignIn();
      }
    });

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: UIColors.pineGreen,
            ),
            child: DrawerHeaderWidget(),
          ),
          if (!offlineState)
            if (profileState.status == UserProfileStatus.loading ||
                updateState.status == UpdateProfileStatus.loading)
              const Center(
                child: CircularProgressIndicator(
                  color: UIColors.pineGreen,
                ),
              )
            else
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  TextConstants.updateProfile,
                  style: AppTypography.regular14Circular(color: UIColors.black),
                ),
                onTap: _navigateToUpdateProfile,
              ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(
              TextConstants.changePassword,
              style: AppTypography.regular14Circular(color: UIColors.black),
            ),
            onTap: _navigateToChangePassword,
          ),
          ListTile(
            leading: logOutState.status == LogOutStatus.loading
                ? SizedBox(
                    height: 20.sp,
                    width: 20.sp,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.sp,
                        color: UIColors.gray,
                      ),
                    ),
                  )
                : const Icon(Icons.logout),
            title: Text(
              TextConstants.logOut,
              style: AppTypography.regular14Circular(color: UIColors.black),
            ),
            onTap: () {
              if (logOutState.status != LogOutStatus.loading) {
                logOutNotifier.logOut();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _logoutAndNavigateToSignIn() async {
    await CacheService.instance.clearBearerToken();
    await CacheService.instance.clearProfileId();

    if (mounted) {
      ShowSnackBarMessage.showSuccessSnackBar(
        message: TextConstants.logOutSuccessful,
        context: context,
      );

      await Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.signIn,
        (Route<dynamic> route) => false,
      );
    }
  }

  void _navigateToChangePassword() {
    Navigator.pop(context);
    Navigator.pushNamed(context, Routes.changePassword);
  }

  void _navigateToUpdateProfile() {
    Navigator.pop(context);

    Navigator.pushNamed(context, Routes.updateProfile);
  }
}
