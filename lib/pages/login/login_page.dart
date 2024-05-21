import 'package:flutter/material.dart';
import 'package:tfg/constants/custom_colors.dart';
import 'package:tfg/constants/custom_fonts.dart';
import 'package:tfg/constants/custom_images.dart';
import 'package:tfg/enums/page_status_enum.dart';
import 'package:tfg/pages/home/home_page.dart';
import 'package:tfg/pages/login/cubit/login_cubit.dart';
import 'package:tfg/widgets/fields/form_input.dart';
import 'package:tfg/widgets/loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class LoginPage extends StatelessWidget {
  static const String route = '/';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.get.white,
      body: BlocProvider(
        create: (_) => LoginCubit(),
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            if (state.pageStatus == PageStatusEnum.loading) {
              return const Loader();
            }

            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .3),
                              child: Image.asset(CustomImages.get.logo, width: MediaQuery.sizeOf(context).width * .3)),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * .35,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                Intl.message('ttt'),
                                style: TextStyle(fontFamily: CustomFonts.get.oxygen_bold, color: CustomColor.get.light_grey, fontSize: 60),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: FormInput(
                                controller: state.usernameInput!,
                                textInputType: TextInputType.text,
                                icon: Icons.person,
                                iconColor: CustomColor.get.light_pink,
                                labelText: Intl.message('username'),
                                borderRadius: 20,
                                alignWithLabel: false,
                                contentPadding: const EdgeInsets.all(20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: FormInput(
                                controller: state.hashtagInput!,
                                textInputType: TextInputType.text,
                                icon: Icons.lock,
                                iconColor: CustomColor.get.light_pink,
                                labelText: Intl.message('hashtag'),
                                borderRadius: 20,
                                alignWithLabel: false,
                                contentPadding: const EdgeInsets.all(20),
                              ),
                            ),
                            state.error != null
                                ? Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      state.error!,
                                      style: TextStyle(fontFamily: CustomFonts.get.oxygen_bold, color: CustomColor.get.red, fontSize: 16),
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(CustomColor.get.light_pink),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)))),
                                      onPressed: () async {
                                        await ReadContext(context).read<LoginCubit>().login() ? Modular.to.pushNamed(HomePage.route) : null;
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 15),
                                        child: Text(
                                          Intl.message('search'),
                                          style: TextStyle(
                                              color: CustomColor.get.light_grey, fontFamily: CustomFonts.get.oxygen_bold, fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
