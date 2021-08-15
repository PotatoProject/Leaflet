import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ShapeTheme {
  final OutlinedBorder smallComponents;
  final OutlinedBorder? buttonShapeOverride;
  final OutlinedBorder? chipShapeOverride;
  final OutlinedBorder? fabShapeOverride;
  final OutlinedBorder? snackbarShapeOverride;
  final OutlinedBorder? tooltipShapeOverride;

  final OutlinedBorder mediumComponents;
  final OutlinedBorder? cardShapeOverride;
  final OutlinedBorder? dialogShapeOverride;
  final OutlinedBorder? imageShapeOverride;
  final OutlinedBorder? menuShapeOverride;

  final OutlinedBorder largeComponents;
  final OutlinedBorder? bottomSheetShapeOverride;
  final OutlinedBorder? pageShapeOverride;

  const ShapeTheme({
    required this.smallComponents,
    this.buttonShapeOverride,
    this.chipShapeOverride,
    this.fabShapeOverride,
    this.snackbarShapeOverride,
    this.tooltipShapeOverride,
    required this.mediumComponents,
    this.cardShapeOverride,
    this.dialogShapeOverride,
    this.imageShapeOverride,
    this.menuShapeOverride,
    required this.largeComponents,
    this.bottomSheetShapeOverride,
    this.pageShapeOverride,
  });

  OutlinedBorder get buttonShape => buttonShapeOverride ?? smallComponents;
  OutlinedBorder get chipShape => chipShapeOverride ?? smallComponents;
  OutlinedBorder get fabShape => fabShapeOverride ?? smallComponents;
  OutlinedBorder get snackbarShape => snackbarShapeOverride ?? smallComponents;
  OutlinedBorder get tooltipShape => tooltipShapeOverride ?? smallComponents;

  OutlinedBorder get cardShape => tooltipShapeOverride ?? mediumComponents;
  OutlinedBorder get dialogShape => dialogShapeOverride ?? mediumComponents;
  OutlinedBorder get imageShape => imageShapeOverride ?? mediumComponents;
  OutlinedBorder get menuShape => menuShapeOverride ?? mediumComponents;

  OutlinedBorder get bottomSheetShape =>
      bottomSheetShapeOverride ?? largeComponents;
  OutlinedBorder get pageShape => pageShapeOverride ?? largeComponents;

  @override
  int get hashCode => Object.hashAll([
        smallComponents,
        buttonShapeOverride,
        chipShapeOverride,
        fabShapeOverride,
        snackbarShapeOverride,
        tooltipShapeOverride,
        mediumComponents,
        cardShapeOverride,
        dialogShapeOverride,
        imageShapeOverride,
        menuShapeOverride,
        largeComponents,
        bottomSheetShapeOverride,
        pageShapeOverride,
      ]);

  @override
  bool operator ==(Object other) {
    if (other is ShapeTheme) {
      return smallComponents == other.smallComponents &&
          buttonShapeOverride == other.buttonShapeOverride &&
          chipShapeOverride == other.chipShapeOverride &&
          fabShapeOverride == other.fabShapeOverride &&
          snackbarShapeOverride == other.snackbarShapeOverride &&
          tooltipShapeOverride == other.tooltipShapeOverride &&
          mediumComponents == other.mediumComponents &&
          cardShapeOverride == other.cardShapeOverride &&
          dialogShapeOverride == other.dialogShapeOverride &&
          imageShapeOverride == other.imageShapeOverride &&
          menuShapeOverride == other.menuShapeOverride &&
          largeComponents == other.largeComponents &&
          bottomSheetShapeOverride == other.bottomSheetShapeOverride &&
          pageShapeOverride == other.pageShapeOverride;
    }

    return false;
  }

  static ShapeTheme lerp(ShapeTheme a, ShapeTheme b, double t) {
    return ShapeTheme(
      smallComponents: ShapeBorder.lerp(
        a.smallComponents,
        b.smallComponents,
        t,
      )! as OutlinedBorder,
      buttonShapeOverride: ShapeBorder.lerp(
        a.buttonShapeOverride,
        b.buttonShapeOverride,
        t,
      ) as OutlinedBorder?,
      chipShapeOverride: ShapeBorder.lerp(
        a.chipShapeOverride,
        b.chipShapeOverride,
        t,
      ) as OutlinedBorder?,
      fabShapeOverride: ShapeBorder.lerp(
        a.fabShapeOverride,
        b.fabShapeOverride,
        t,
      ) as OutlinedBorder?,
      snackbarShapeOverride: ShapeBorder.lerp(
        a.snackbarShapeOverride,
        b.snackbarShapeOverride,
        t,
      ) as OutlinedBorder?,
      tooltipShapeOverride: ShapeBorder.lerp(
        a.tooltipShapeOverride,
        b.tooltipShapeOverride,
        t,
      ) as OutlinedBorder?,
      mediumComponents: ShapeBorder.lerp(
        a.mediumComponents,
        b.mediumComponents,
        t,
      )! as OutlinedBorder,
      cardShapeOverride: ShapeBorder.lerp(
        a.cardShapeOverride,
        b.cardShapeOverride,
        t,
      ) as OutlinedBorder?,
      dialogShapeOverride: ShapeBorder.lerp(
        a.dialogShapeOverride,
        b.dialogShapeOverride,
        t,
      ) as OutlinedBorder?,
      imageShapeOverride: ShapeBorder.lerp(
        a.imageShapeOverride,
        b.imageShapeOverride,
        t,
      ) as OutlinedBorder?,
      menuShapeOverride: ShapeBorder.lerp(
        a.menuShapeOverride,
        b.menuShapeOverride,
        t,
      ) as OutlinedBorder?,
      largeComponents: ShapeBorder.lerp(
        a.largeComponents,
        b.largeComponents,
        t,
      )! as OutlinedBorder,
      bottomSheetShapeOverride: ShapeBorder.lerp(
        a.bottomSheetShapeOverride,
        b.bottomSheetShapeOverride,
        t,
      ) as OutlinedBorder?,
      pageShapeOverride: ShapeBorder.lerp(
        a.pageShapeOverride,
        b.pageShapeOverride,
        t,
      ) as OutlinedBorder?,
    );
  }
}
