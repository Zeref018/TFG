import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tfg/base_cubit/base_cubit.dart';
import 'package:tfg/constants/custom_colors.dart';
import 'package:tfg/constants/custom_fonts.dart';
import 'package:tfg/enums/page_status_enum.dart';
import 'package:tfg/pages/home/cubit/home_cubit.dart';
import 'package:tfg/pages/login/login_page.dart';
import 'package:tfg/widgets/loader.dart';
import 'package:tfg/repositories/preferences_repository.dart';
import 'package:tfg/constants/memory.dart';
import 'package:tfg/pages/match_history/match_history_page.dart';
import 'package:tfg/constants/custom_images.dart'; // Asegúrate de tener esta importación para el logo

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

              // Construye la ruta de la imagen basada en el rango SoloQ
              String soloQImagePath = 'images/${state.soloQRank?.tier ?? 'default'}.png';

              // Construye la ruta de la imagen basada en el rango FlexQ
              String flexQImagePath = 'images/${state.flexQRank?.tier ?? 'default'}.png';

              // Verificar si ambos están sin clasificar ('unranked')
              bool soloQUnranked = state.soloQRank?.tier == null;
              bool flexQUnranked = state.flexQRank?.tier == null;

              return Scaffold(
                backgroundColor: Colors.grey[850],
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => BlocProvider.of<HomeCubit>(context).setLogout(),
                                    icon: Icon(Icons.arrow_back_rounded, color: Colors.blueAccent),
                                  ),
                                  if (state.profileIconId != null)
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        'https://ddragon.leagueoflegends.com/cdn/${M.patch}/img/profileicon/${state.profileIconId}.png',
                                      ),
                                      radius: 20,
                                    ),
                                  SizedBox(width: 8),
                                  FutureBuilder<String?>(
                                    future: PreferencesRepository().getUsername(),
                                    builder: (context, usernameSnapshot) {
                                      if (usernameSnapshot.connectionState == ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else {
                                        String username = usernameSnapshot.data ?? '';
                                        return FutureBuilder<String?>(
                                          future: PreferencesRepository().getHashtag(),
                                          builder: (context, hashtagSnapshot) {
                                            if (hashtagSnapshot.connectionState == ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else {
                                              String hashtag = hashtagSnapshot.data ?? '';
                                              return Text(
                                                '$username#$hashtag',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              // Logo en la esquina superior derecha
                              Image.asset(
                                CustomImages.get.logo,
                                width: 70,
                                height: 70,
                              ),
                            ],
                          ),
                          SizedBox(height: 20), // Espacio entre las secciones
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Sección SoloQ
                              Expanded(
                                child: Column(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: MediaQuery.of(context).size.height * 0.3,
                                      ),
                                      child: Image.asset(
                                        soloQImagePath,
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        errorBuilder: (context, error, stackTrace) {
                                          // Mensaje de depuración
                                          print('Error loading SoloQ image: $error');
                                          return Image.asset('images/default.png'); // Imagen de fallback
                                        },
                                      ),
                                    ),
                                    // Datos SoloQ
                                    if (soloQUnranked)
                                      Text(
                                        'SoloQ Rank: unranked',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontFamily: CustomFonts.get.oxygen_bold,
                                        ),
                                      )
                                    else
                                      Column(
                                        children: [
                                          Text(
                                            'SoloQ Rank: ${state.soloQRank?.tier} ${state.soloQRank?.rank} ${state.soloQRank?.leaguePoints} LPs',
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontFamily: CustomFonts.get.oxygen_bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Wins: ${state.soloQRank?.wins ?? 0}',
                                                style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontFamily: CustomFonts.get.oxygen_bold,
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              Text(
                                                'Losses: ${state.soloQRank?.losses ?? 0}',
                                                style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontFamily: CustomFonts.get.oxygen_bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Win Rate: ${((state.soloQRank?.wins ?? 0) / ((state.soloQRank?.wins ?? 0) + (state.soloQRank?.losses ?? 0)) * 100).toInt()}%',
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontFamily: CustomFonts.get.oxygen_bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20), // Espacio entre SoloQ y FlexQ
                              // Sección FlexQ
                              Expanded(
                                child: Column(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: MediaQuery.of(context).size.height * 0.3,
                                      ),
                                      child: Image.asset(
                                        flexQImagePath,
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        errorBuilder: (context, error, stackTrace) {
                                          // Mensaje de depuración
                                          print('Error loading FlexQ image: $error');
                                          return Image.asset('images/default.png'); // Imagen de fallback
                                        },
                                      ),
                                    ),
                                    // Datos FlexQ
                                    if (flexQUnranked)
                                      Text(
                                        'FlexQ Rank: unranked',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontFamily: CustomFonts.get.oxygen_bold,
                                        ),
                                      )
                                    else
                                      Column(
                                        children: [
                                          Text(
                                            'FlexQ Rank: ${state.flexQRank?.tier} ${state.flexQRank?.rank} ${state.flexQRank?.leaguePoints} LPs',
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontFamily: CustomFonts.get.oxygen_bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Wins: ${state.flexQRank?.wins ?? 0}',
                                                style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontFamily: CustomFonts.get.oxygen_bold,
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              Text(
                                                'Losses: ${state.flexQRank?.losses ?? 0}',
                                                style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontFamily: CustomFonts.get.oxygen_bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Win Rate: ${((state.flexQRank?.wins ?? 0) / ((state.flexQRank?.wins ?? 0) + (state.flexQRank?.losses ?? 0)) * 100).toInt()}%',
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontFamily: CustomFonts.get.oxygen_bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20), // Espacio entre las secciones y el botón de refrescar
                          ElevatedButton(
                            onPressed: () {
                              Modular.to.pushNamed('/match_history');
                            },
                            child: Text(
                              'Ver historial de partidas',
                              style: TextStyle(color: Colors.white), // Establecer el color del texto a blanco
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
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
