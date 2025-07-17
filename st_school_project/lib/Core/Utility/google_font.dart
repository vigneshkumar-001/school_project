import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';

class GoogleFont{
  static ibmPlexSans({double fontSize =14, FontWeight? fontWeight, letterSpacing,Color? color}) {
    return GoogleFonts.ibmPlexSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
        letterSpacing:letterSpacing,
    );
  }

  static inter({double fontSize = 18, FontWeight? fontWeight, Color? color}) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,

    );
  }
}
