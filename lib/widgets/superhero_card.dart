import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/model/alignment_info.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';

class SuperheroCard extends StatelessWidget {
  final SuperheroInfo superheroInfo;
  final VoidCallback onTap;

  const SuperheroCard({
    Key? key,
    required this.superheroInfo,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: SuperheroesColors.indigo,
        ),
        child: Row(
          children: [
            _AvatarWidget(superheroInfo: superheroInfo),
            const SizedBox(width: 12),
            NameAndRealNameWidget(superheroInfo: superheroInfo),
            if (superheroInfo.alignmentInfo != null)
              AlignmentWidget(alignmentInfo: superheroInfo.alignmentInfo!)
          ],
        ),
      ),
    );
  }
}

class AlignmentWidget extends StatelessWidget {
  final AlignmentInfo alignmentInfo;

  const AlignmentWidget({Key? key, required this.alignmentInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 6),
        color: alignmentInfo.color,
        child: Text(
          alignmentInfo.name.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

class NameAndRealNameWidget extends StatelessWidget {
  const NameAndRealNameWidget({
    Key? key,
    required this.superheroInfo,
  }) : super(key: key);

  final SuperheroInfo superheroInfo;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            superheroInfo.name.toUpperCase(),
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          Text(
            superheroInfo.realName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget({
    Key? key,
    required this.superheroInfo,
  }) : super(key: key);

  final SuperheroInfo superheroInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white24,
      width: 70,
      height: 70,
      child: CachedNetworkImage(
        imageUrl: superheroInfo.imageUrl,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(value: downloadProgress.progress),
          ),
        ),
        errorWidget: (context, url, error) => Center(
          child: Image.asset(
            SuperheroesImages.unknown,
            width: 20,
            height: 62,
          ),
        ),
      ),
    );
  }
}
