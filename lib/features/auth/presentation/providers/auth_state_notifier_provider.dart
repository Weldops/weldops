import 'package:esab/features/auth/presentation/providers/state/google_signin_notifier.dart';
import 'package:esab/features/auth/presentation/providers/state/google_signin_state.dart';
import 'package:esab/features/auth/presentation/providers/state/resend_email_notifier.dart';
import 'package:esab/features/auth/presentation/providers/state/resend_email_state.dart';
import 'package:esab/features/auth/presentation/providers/state/sign_in_notifier.dart';
import 'package:esab/features/auth/presentation/providers/state/sign_in_state.dart';
import 'package:esab/features/auth/presentation/providers/state/create_account_notifier.dart';
import 'package:esab/features/auth/presentation/providers/state/create_account_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signInStateNotifierProvider =
    StateNotifierProvider<SignInNotifier, SignInState>(
        (ref) => SignInNotifier());

final createAccountStateNotifierProvider =
    StateNotifierProvider<CreateAccountNotifier, CreateAccountState>(
        (ref) => CreateAccountNotifier());

final googleSignInStateNotifierProvider =
    StateNotifierProvider<GoogleSignInNotifier, GoogleSignInState>(
        (ref) => GoogleSignInNotifier());

final resendEmailStateNotifierProvider =
    StateNotifierProvider<ResendEmailNotifier, ResendEmailState>(
        (ref) => ResendEmailNotifier());
