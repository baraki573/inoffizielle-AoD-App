import 'package:flutter/widgets.dart';

double size(double portrait, double landscape) {
	return SizeConfig.orientationDevice == Orientation.portrait
			? portrait
			: landscape;
}

double horSize(double portrait, double landscape, {left=false, right=false}) {
	var offset = left ? SizeConfig.padding.left : 0;
	offset += right ? SizeConfig.padding.right : 0;
	return offset + SizeConfig.safeBlockHorizontal * size(portrait, landscape);
}

double verSize(double portrait, double landscape, {top=false, bottom=false}) {
	var offset = top ? SizeConfig.padding.top : 0;
	offset += bottom ? SizeConfig.padding.bottom : 0;
	return offset + SizeConfig.safeBlockVertical * size(portrait, landscape);
}

class SizeConfig {
			static MediaQueryData _mediaQueryData;
			static double screenWidth;
			static double screenHeight;
			static double blockSizeHorizontal;
			static double blockSizeVertical;
			
			static double _safeAreaHorizontal;
			static double _safeAreaVertical;
			static double safeBlockHorizontal;
			static double safeBlockVertical;
      static Orientation orientationDevice;
      static EdgeInsets padding;
			
			void init(BuildContext context) {
				_mediaQueryData = MediaQuery.of(context);
				screenWidth = _mediaQueryData.size.width;
				screenHeight = _mediaQueryData.size.height;
				blockSizeHorizontal = screenWidth / 100;
				blockSizeVertical = screenHeight / 100;
        orientationDevice = _mediaQueryData.orientation;

				_safeAreaHorizontal = _mediaQueryData.padding.left +
					_mediaQueryData.padding.right;
				_safeAreaVertical = _mediaQueryData.padding.top +
					_mediaQueryData.padding.bottom;
				safeBlockHorizontal = (screenWidth -
					_safeAreaHorizontal) / 100;
				safeBlockVertical = (screenHeight -
					_safeAreaVertical) / 100;

				padding = _mediaQueryData.padding;
			}
		}