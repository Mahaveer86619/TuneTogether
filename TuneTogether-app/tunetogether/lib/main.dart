import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tunetogether/common/app_routes/app_routes.dart';
import 'package:tunetogether/common/app_user_cubit/app_user_cubit.dart';
import 'package:tunetogether/core/services/notifications.dart';
import 'package:tunetogether/core/theme/app_theme.dart';
import 'package:tunetogether/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tunetogether/features/home/presentation/bloc/home_bloc.dart';
import 'package:tunetogether/injection_container.dart' as di;

void main() {
  setup();
  runApp(const MyApp());
}

void setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  dotenv.load(fileName: '.env');

  await di.registerDependencies();
  await setupNotificationChannels();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppUserCubit>(
          create: (context) => di.sl<AppUserCubit>(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => di.sl<HomeBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'TuneTogether',
        theme: lightMode,
        darkTheme: darkMode,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}
