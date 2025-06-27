import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum ImageType {
  widget,
  network,
  networkSvg,
  storage,
  storageSvg,
  assets,
  assetSvg,
  none,
}

class ImageViewer extends StatefulWidget {
  final dynamic url;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final Widget? placeholder;
  final Size? size;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final void Function()? onTap;

  const ImageViewer({
    super.key,
    required this.url,
    this.decoration,
    this.padding,
    this.placeholder,
    this.size,
    this.fit,
    this.alignment = Alignment.center,
    this.onTap,
  }) : assert(url != null, 'Image url must be provided.');

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> with AutomaticKeepAliveClientMixin {
  ImageType get type {
    if (widget.url is Widget) return ImageType.widget;
    if (widget.url is String) {
      if (widget.url.isNetwork) {
        if (widget.url.isSvg) {
          return ImageType.networkSvg;
        }
        return ImageType.network;
      } else if (widget.url.isStaticAssets) {
        if (widget.url.isSvg) {
          return ImageType.assetSvg;
        }
        return ImageType.assets;
      } else if (widget.url.isStorage) {
        if (widget.url.isSvg) {
          return ImageType.storageSvg;
        }
        return ImageType.storage;
      }
    }
    return ImageType.none;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InkWell(
      onTap: () {
        if (widget.onTap == null) return;
        widget.onTap!();
      },
      borderRadius: widget.decoration?.borderRadius as BorderRadius,
      child: Ink(
        decoration: widget.decoration,
        padding: widget.padding,
        width: widget.size?.width,
        height: widget.size?.height,
        child: buildImage(context),
      ),
    );
  }

  Widget buildImage(BuildContext context) => switch (type) {
        ImageType.widget => widget.url,
        ImageType.network => buildNetworkImage(context),
        ImageType.networkSvg => buildNetworkImage(context, isSvg: true),
        ImageType.storage => buildStorageImage(context),
        ImageType.storageSvg => buildStorageImage(context, isSvg: true),
        ImageType.assets => buildAssetsImage(context),
        ImageType.assetSvg => buildAssetsImage(context, isSvg: true),
        ImageType.none => widget.placeholder ?? const Placeholder(),
      };

  Widget seletonizer(
    BuildContext context, {
    Widget? child,
    double? frame,
  }) =>
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: (frame != null || frame == 100) && child != null
            ? child
            : Skeletonizer(
                enabled: true,
                child: Container(
                  height: widget.size?.height,
                  width: widget.size?.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
      );

  Widget buildAssetsImage(
    BuildContext context, {
    bool isSvg = false,
  }) =>
      isSvg
          ? buildSvgImage(context, isAssets: true)
          : Image.asset(
              widget.url,
              height: widget.size?.height,
              width: widget.size?.width,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                  wasSynchronouslyLoaded ? child : seletonizer(context, child: child, frame: frame?.toDouble()),
              errorBuilder: (context, error, stackTrace) => widget.placeholder ?? const Placeholder(),
              fit: widget.fit,
              alignment: widget.alignment,
            );

  Widget buildNetworkImage(
    BuildContext context, {
    bool isSvg = false,
  }) =>
      isSvg
          ? buildSvgImage(context, isNetwork: true)
          : CachedNetworkImage(
              placeholder: (context, url) => widget.placeholder ?? const Placeholder(),
              imageBuilder: (context, imageProvider) => seletonizer(context),
              errorWidget: (context, url, error) => widget.placeholder ?? const Placeholder(),
              progressIndicatorBuilder: (context, url, progress) => seletonizer(context, frame: progress.progress),
              imageUrl: widget.url,
              width: widget.size?.width,
              height: widget.size?.height,
              fit: widget.fit ?? BoxFit.contain,
              alignment: widget.alignment as Alignment,
            );

  Widget buildStorageImage(
    BuildContext context, {
    bool isSvg = false,
  }) =>
      isSvg
          ? buildSvgImage(context, isStorage: true)
          : Image.file(
              File(widget.url),
              width: widget.size?.width,
              height: widget.size?.height,
              fit: widget.fit ?? BoxFit.contain,
              alignment: widget.alignment,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                  wasSynchronouslyLoaded ? child : seletonizer(context, child: child, frame: frame?.toDouble()),
              errorBuilder: (context, error, stackTrace) => widget.placeholder ?? const Placeholder(),
            );

  Widget buildSvgImage(
    BuildContext context, {
    bool isNetwork = false,
    bool isAssets = false,
    bool isStorage = false,
  }) {
    if (isNetwork) {
      return CachedNetworkSVGImage(
        widget.url,
        placeholder: seletonizer(context),
        errorWidget: widget.placeholder ?? const Placeholder(),
        width: widget.size?.width,
        height: widget.size?.height,
        fadeDuration: const Duration(milliseconds: 300),
        fit: widget.fit ?? BoxFit.contain,
        alignment: widget.alignment,
      );
    }
    if (isAssets) {
      return SvgPicture.asset(
        widget.url,
        width: widget.size?.width,
        height: widget.size?.height,
        fit: widget.fit ?? BoxFit.contain,
        alignment: widget.alignment,
        placeholderBuilder: (context) => seletonizer(context),
      );
    }
    if (isStorage) {
      return SvgPicture.file(
        File(widget.url),
        width: widget.size?.width,
        height: widget.size?.height,
        fit: widget.fit ?? BoxFit.contain,
        alignment: widget.alignment,
        placeholderBuilder: (context) => seletonizer(context),
      );
    }

    return widget.placeholder ?? const Placeholder();
  }

  @override
  bool get wantKeepAlive => type != ImageType.none;
}
