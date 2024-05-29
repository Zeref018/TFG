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

              String soloQImagePath = 'images/${state.soloQRank?.tier ?? 'default'}.png';
              String flexQImagePath = 'images/${state.flexQRank?.tier ?? 'default'}.png';

              bool soloQUnranked = state.soloQRank?.tier == null;
              bool flexQUnranked = state.flexQRank?.tier == null;

              return Scaffold(
                backgroundColor: Colors.grey[850],
                body: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
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
                                Image.asset(
                                  CustomImages.get.logo,
                                  width: 70,
                                  height: 70,
                                ),
                              ],
                            ),
                            SizedBox(height: 30), // Añadir más margen entre el encabezado y el contenido
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        'SOLO Q',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontFamily: CustomFonts.get.oxygen_bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context).size.height * 0.3,
                                        ),
                                        child: Image.asset(
                                          soloQImagePath,
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          errorBuilder: (context, error, stackTrace) {
                                            print('Error loading SoloQ image: $error');
                                            return Image.asset('images/default.png');
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      if (soloQUnranked)
                                        Text(
                                          'unranked',
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontFamily: CustomFonts.get.oxygen_bold,
                                            fontSize: 16,
                                          ),
                                        )
                                      else
                                        Column(
                                          children: [
                                            Text(
                                              '${state.soloQRank?.tier} ${state.soloQRank?.rank} ${state.soloQRank?.leaguePoints} LPs',
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontFamily: CustomFonts.get.oxygen_bold,
                                                fontSize: 16,
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
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Losses: ${state.soloQRank?.losses ?? 0}',
                                                  style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontFamily: CustomFonts.get.oxygen_bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'Win Rate: ${((state.soloQRank?.wins ?? 0) / ((state.soloQRank?.wins ?? 0) + (state.soloQRank?.losses ?? 0)) * 100).toInt()}%',
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontFamily: CustomFonts.get.oxygen_bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        'FLEX Q',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontFamily: CustomFonts.get.oxygen_bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context).size.height * 0.3,
                                        ),
                                        child: Image.asset(
                                          flexQImagePath,
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          errorBuilder: (context, error, stackTrace) {
                                            print('Error loading FlexQ image: $error');
                                            return Image.asset('images/default.png');
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      if (flexQUnranked)
                                        Text(
                                          'unranked',
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontFamily: CustomFonts.get.oxygen_bold,
                                            fontSize: 16,
                                          ),
                                        )
                                      else
                                        Column(
                                          children: [
                                            Text(
                                              '${state.flexQRank?.tier} ${state.flexQRank?.rank} ${state.flexQRank?.leaguePoints} LPs',
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontFamily: CustomFonts.get.oxygen_bold,
                                                fontSize: 16,
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
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Losses: ${state.flexQRank?.losses ?? 0}',
                                                  style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontFamily: CustomFonts.get.oxygen_bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'Win Rate: ${((state.flexQRank?.wins ?? 0) / ((state.flexQRank?.wins ?? 0) + (state.flexQRank?.losses ?? 0)) * 100).toInt()}%',
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontFamily: CustomFonts.get.oxygen_bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: () {
                              Modular.to.pushNamed('/match_history');
                            },
                            child: Text(
                              'Ver historial de partidas',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
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
