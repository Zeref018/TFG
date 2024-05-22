import 'package:flutter/material.dart';
import 'package:tfg/base_cubit/base_cubit.dart';
import 'package:tfg/constants/custom_colors.dart';
import 'package:tfg/constants/custom_fonts.dart';
import 'package:tfg/enums/page_status_enum.dart';
import 'package:tfg/pages/home/cubit/home_cubit.dart';
import 'package:tfg/pages/login/login_page.dart';
import 'package:tfg/widgets/loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  static const String url = '/';
  static const String route = '/home/';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseCubit, BaseState>(
      builder: (context, state) {
        return BlocProvider(
          create: (context) => HomeCubit(),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state.pageStatus == PageStatusEnum.loading) {
                return const Loader();
              }

              if (state.pageStatus == PageStatusEnum.logout) {
                Modular.to.pushReplacementNamed(LoginPage.route);
                return Container();
              }

              // Construye la ruta de la imagen basada en el rango
              String? tier = state.soloQRank?.tier.toLowerCase();
              String imagePath = tier != null
                  ? 'images/$tier.png'
                  : 'images/default.png'; // Ruta de imagen por defecto si tier es null

              return Scaffold(
                backgroundColor: CustomColor.get.white,
                body: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0), // Añadir espacio en todas las direcciones
                        child: Row(
                          children: [
                            // Mostrar el icono del perfil si está disponible
                            if (state.profileIconId != null)
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'https://ddragon.leagueoflegends.com/cdn/14.10.1/img/profileicon/${state.profileIconId}.png',
                                ),
                              ),
                            SizedBox(width: 16), // Espacio entre el avatar y el resto del contenido
                            Text(
                              'Welcome', // Puedes personalizar el texto aquí
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(), // Espaciado flexible para colocar los elementos a la derecha
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                                ),
                                child: Image.asset(
                                  imagePath,
                                  width: MediaQuery.of(context).size.width * 0.3,
                                ),
                              ),
                              IconButton(
                                onPressed: () => BlocProvider.of<HomeCubit>(context).setLogout(),
                                icon: Icon(Icons.arrow_back_rounded, color: CustomColor.get.light_pink),
                              ),

                              state.soloQRank != null || state.flexQRank != null
                                  ? Column(
                                children: [
                                  Text(
                                    'SoloQ Rank: ${state.soloQRank?.tier} ${state.soloQRank?.rank} ${state.soloQRank?.leaguePoints} LPs',
                                    style: TextStyle(
                                      color: CustomColor.get.light_pink,
                                      fontFamily: CustomFonts.get.oxygen_bold,
                                    ),
                                  ),
                                  Text(
                                    'FlexQ Rank: ${state.flexQRank?.tier} ${state.flexQRank?.rank} ${state.flexQRank?.leaguePoints} LPs',
                                    style: TextStyle(
                                      color: CustomColor.get.light_pink,
                                      fontFamily: CustomFonts.get.oxygen_bold,
                                    ),
                                  ),
                                ],
                              )
                                  : Loader(),
                              // Botón de refresh sin acción
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.refresh, color: CustomColor.get.light_pink),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
