// ignore_for_file: non_constant_identifier_names

class Sizes {
  const Sizes();

  static const Sizes get = Sizes();

  int get breakpoint_1920 => 1920;

  int get breakpoint_1440 => 1440;

  int get breakpoint_1320 => 1320;

  int get breakpoint_1024 => 1024;

  int get breakpoint_768 => 768;

  int get breakpoint_560 => 560;

  int get breakpoint_520 => 520;

  int get breakpoint_425 => 425;

  int get breakpoint_362 => 362;

  bool isTableOrMobile(double width) => breakpoint_1024 >= width;
}
