import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:media_guard_v2/core/constaints/assets_path.dart';
import 'package:media_guard_v2/core/extensions/color_extension.dart';
import 'package:media_guard_v2/domain/models/guard_album_model.dart';

class AlbumListGrid extends StatelessWidget {
  final List<GuardAlbumModel> albums;
  final Function(GuardAlbumModel) onAlbumTap;

  const AlbumListGrid({super.key, required this.albums, required this.onAlbumTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 6.0,
        mainAxisSpacing: 6.0,
      ),
      itemCount: albums.length,
      padding: EdgeInsets.only(top: 8.0, bottom: MediaQuery.of(context).padding.bottom + 6.0, left: 6.0, right: 6.0),
      itemBuilder: (context, index) {
        return _buildAlbumItem(albums[index]);
      },
      physics: const BouncingScrollPhysics(),
    );
  }

  Widget _buildAlbumItem(GuardAlbumModel album) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        return GestureDetector(
          onTap: () => onAlbumTap(album),
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildAlbumThumbnail(album, size),
                _buildAlbumTitle(album),
                _buildPasswordIndicator(album),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlbumThumbnail(GuardAlbumModel album, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Builder(
          builder: (context) {
            if (album.password != null || album.fileThumbailPath == null || album.fileThumbailPath!.isEmpty) {
              return _buildPlacehoderImage(width: size, height: size);
            } else {
              return Image.file(
                File(album.fileThumbailPath!),
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlacehoderImage(width: size, height: size);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildPlacehoderImage({
    double width = 50,
    double height = 50,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      color: Color(0xFFEBEEF2),
      child: SvgPicture.asset(
        AssetsPath.icImageSecurity,
        width: 50,
        height: 50,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(
          Colors.grey.shade600,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildAlbumTitle(GuardAlbumModel album) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(4.0),
            bottomRight: Radius.circular(4.0),
          ),
          color: Colors.black.withOpacityValue(0.3),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              album.name,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordIndicator(GuardAlbumModel album) {
    if (album.password == null) {
      return const SizedBox.shrink();
    }
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.lock,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
}
