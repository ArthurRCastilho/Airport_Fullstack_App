import 'package:api_aeroporto/features/home/presentation/widgets/error_msg.dart';
import 'package:api_aeroporto/features/home/presentation/widgets/list_cards.dart';
import 'package:api_aeroporto/features/home/presentation/widgets/passageiros/add_new_passageiro_dialog.dart';
import 'package:api_aeroporto/features/home/presentation/widgets/passageiros/card_passageiro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api_aeroporto/features/home/presentation/viewmodels/passageiros_view_model.dart';
import 'package:api_aeroporto/features/auth/presentation/views/login_screen.dart';

class PassageirosView extends StatefulWidget {
  const PassageirosView({super.key});

  @override
  State<PassageirosView> createState() => PassageirosViewState();
}

class PassageirosViewState extends State<PassageirosView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PassageirosViewModel>().loadPassageiros(),
    );
  }

  void showAddPassageiroDialog(BuildContext context) {
    final viewModel = context.read<PassageirosViewModel>();
    viewModel.resetForm();
    viewModel.loadVoosDisponiveis();

    showDialog(
      context: context,
      builder:
          (context) => AddNewPassageiroDialog(mounted: mounted),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PassageirosViewModel>(
      builder: (context, viewModel, child) {
        // Navegação condicional para login em caso de erro de token
        if (!viewModel.isLoading &&
            (viewModel.error?.contains('Token inválido ou expirado') ==
                    true ||
                viewModel.error?.contains('Token não encontrado') ==
                    true)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            }
          });
        }

        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error != null) {
          return ErrorMsg(
            errorMsg: viewModel.error!,
            onPressed: () => viewModel.loadPassageiros(),
          );
        }

        if (viewModel.passageiros.isEmpty) {
          return const Center(child: Text('Nenhum passageiro encontrado'));
        }

        return ListCards(
          itemCount: viewModel.passageiros.length,
          itemBuilder: (context, index) {
            final passageiro = viewModel.passageiros[index];
            return CardPassageiro(passageiro: passageiro);
          },
        );
      },
    );
  }
}

