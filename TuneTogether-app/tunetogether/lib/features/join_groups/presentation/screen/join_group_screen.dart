import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunetogether/features/home/presentation/widgets/group_tile.dart';
import 'package:tunetogether/features/join_groups/presentation/bloc/join_group_bloc.dart';

class JoinGroupsScreen extends StatefulWidget {
  const JoinGroupsScreen({super.key});

  @override
  State<JoinGroupsScreen> createState() => _JoinGroupsScreenState();
}

class _JoinGroupsScreenState extends State<JoinGroupsScreen> {
  void _changeScreen(
    String routeName, {
    Map<String, dynamic>? arguments,
    bool isReplacement = false,
  }) {
    if (isReplacement) {
      Navigator.pushReplacementNamed(
        context,
        routeName,
        arguments: arguments,
      );
    } else {
      Navigator.pushNamed(
        context,
        routeName,
        arguments: arguments,
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getPublicGroups() {
    context.read<JoinGroupBloc>().add(GetPublicGroups());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 12,
          ),
          child: _buildBody(context),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Join Groups'),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<JoinGroupBloc, JoinGroupState>(
      listener: (context, state) {
        if (state is JoinGroupError) {
          _showMessage(state.message);
        }
      },
      builder: (context, state) {
        if (state is JoinGroupInitial) {
          _getPublicGroups();
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is JoinGroupLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PublicGroupsLoaded) {
          if (state.groups.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No public groups available',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: state.groups.length,
            itemBuilder: (context, index) {
              final group = state.groups[index];
              return GroupTile(group: group);
            },
          );
        }
        return Column(
          children: [
            Text('Join Groups Screen'),
          ],
        );
      },
    );
  }
}
