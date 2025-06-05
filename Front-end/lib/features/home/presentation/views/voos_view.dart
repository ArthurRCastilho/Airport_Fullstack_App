import 'package:api_aeroporto/features/home/presentation/widgets/error_msg.dart';
import 'package:api_aeroporto/features/home/presentation/widgets/list_cards.dart';
import 'package:api_aeroporto/features/home/presentation/widgets/voos/add_new_voo_dialog.dart';
import 'package:api_aeroporto/features/home/presentation/widgets/voos/card_voo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api_aeroporto/features/home/presentation/viewmodels/voos_view_model.dart';
import 'package:api_aeroporto/features/auth/presentation/views/login_screen.dart';
import 'package:intl/intl.dart';

class VoosView extends StatefulWidget {
  const VoosView({super.key});

  @override
  State<VoosView> createState() => VoosViewState();
}

class VoosViewState extends State<VoosView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<VoosViewModel>().loadVoos());
  }

  void showAddVooDialog(BuildContext context) {
    final viewModel = context.read<VoosViewModel>();
    viewModel.resetForm();
    viewModel.loadPortoesDisponiveis();

    showDialog(
      context: context,
      builder: (context) => AddNewVooDialog(mounted: mounted),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VoosViewModel>(
      builder: (context, viewModel, child) {
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
            onPressed: () => viewModel.loadVoos(),
          );
        }

        if (viewModel.voos.isEmpty) {
          return const Center(child: Text('Nenhum voo encontrado'));
        }

        return ListCards(
          itemCount: viewModel.voos.length,
          itemBuilder: (context, index) {
            final voo = viewModel.voos[index];
            final formattedDate = DateFormat(
              'dd/MM/yyyy HH:mm',
            ).format(voo.dataHoraPartida);
            return CardVoo(voo: voo, formattedDate: formattedDate);
          },
        );
      },
    );
  }
}
