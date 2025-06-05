import 'package:api_aeroporto/features/auth/presentation/views/login_screen.dart';
import 'package:api_aeroporto/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:api_aeroporto/features/home/presentation/views/passageiros_view.dart';
import 'package:api_aeroporto/features/home/presentation/views/portoes_view.dart';
import 'package:api_aeroporto/features/home/presentation/views/voos_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _portoesKey = GlobalKey<PortoesViewState>();
  final _voosKey = GlobalKey<VoosViewState>();
  final _passageirosKey = GlobalKey<PassageirosViewState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<HomeViewModel>().checkUserPermission(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(viewModel.currentScreenTitle),
            actions: [
              if (viewModel.canManagePortoes)
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (viewModel.currentScreen == 0) {
                      // Se estiver na tela de portões, mostra o diálogo de adicionar portão
                      _portoesKey.currentState?.showAddPortaoDialog(
                        context,
                      );
                    }
                    if (viewModel.currentScreen == 1) {
                      // Se estiver na tela de voos, mostra o diálogo de adicionar voo
                      _voosKey.currentState?.showAddVooDialog(context);
                    }
                    if (viewModel.currentScreen == 2) {
                      _passageirosKey.currentState
                          ?.showAddPassageiroDialog(context);
                    }
                  },
                ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await viewModel.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
          body: IndexedStack(
            index: viewModel.currentScreen,
            children: [
              PortoesView(key: _portoesKey),
              VoosView(key: _voosKey),
              PassageirosView(key: _passageirosKey),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: viewModel.currentScreen,
            onDestinationSelected: viewModel.setCurrentScreen,
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 8,
            height: 65,
            labelBehavior:
                NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.door_front_door_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                selectedIcon: Icon(
                  Icons.door_front_door,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'Portões',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.flight_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                selectedIcon: Icon(
                  Icons.flight,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'Voos',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.person_outline,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                selectedIcon: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'Passageiros',
              ),
            ],
          ),
        );
      },
    );
  }
}
