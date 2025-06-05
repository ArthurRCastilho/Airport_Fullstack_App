import 'package:api_aeroporto/features/home/presentation/widgets/error_msg.dart';
import 'package:api_aeroporto/features/home/presentation/widgets/list_cards.dart';
import 'package:api_aeroporto/features/home/presentation/widgets/portoes/add_portao_dialog.dart';
import 'package:api_aeroporto/features/home/presentation/widgets/portoes/card_portao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api_aeroporto/features/home/presentation/viewmodels/portoes_view_model.dart';
import 'package:api_aeroporto/features/auth/presentation/views/login_screen.dart';

class PortoesView extends StatefulWidget {
  const PortoesView({super.key});

  @override
  State<PortoesView> createState() => PortoesViewState();
}

class PortoesViewState extends State<PortoesView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PortoesViewModel>().loadPortoes());
  }

  void showAddPortaoDialog(BuildContext context) {
    final viewModel = context.read<PortoesViewModel>();
    viewModel.resetForm();

    showDialog(
      context: context,
      builder:
          (context) => AddPortaoDialog(mounted: mounted),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PortoesViewModel>(
      builder: (context, viewModel, child) {
        // Verificar token inválido
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

        // Loading
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Erro
        if (viewModel.error != null) {
          return ErrorMsg(
            errorMsg: viewModel.error!,
            onPressed: () => viewModel.loadPortoes(),
          );
        }

        // Lista vazia
        if (viewModel.portoes.isEmpty) {
          return const Center(child: Text('Nenhum portão encontrado'));
        }

        // Lista de portões
        return ListCards(
          itemCount: viewModel.portoes.length,
          itemBuilder: (context, index) {
            final portao = viewModel.portoes[index];
            return CardPortao(portao: portao);
          },
        );
      },
    );
  }
}
