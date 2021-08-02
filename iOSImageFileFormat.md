[[_TOC_]]
# iOS Image File Format

Image assets officially support multiple file formats including PNG, PDF and SVG. The recommended image file format for iOS images is SVG images with "Preserve Vector Data" option disabled in Xcode. There's no significant difference in size or performance between PDF and SVG images when "Preserve Vector Data" option is disabled, but SVG images are easier share across all platforms.

## Vector based image file format Overview
When a single scale PDF or SVG image with "Preserve Vector Data" option disabled is used for an imageset, Xcode generates corresponding @1x, @2x, or @3x PNG images depending on the build target at build time. At runtime, the application loads the PNG image from the app bundle, so the runtime behavior is the same as if PNG images are provided for the imageset.

When a single scale PDF or SVG image with "Preserve Vector Data" option enabled is used for an imageset, XCode adds the image vector data to the app bundle at build time. This option is useful if the image is expected to be stretched. At runtime, if the image is drawn at a different size from the intrinsic image size, the vector data will be used so that the image does not appear blurry.

Stretching an image is not supported or necessary in most scenarios such as displayed within a button; however, in the rare cases when an image needs to fill a variable size such as the entire screen, streching an image is indeed necessary.

## Bundle Size Impact
When vector data is disabled, the bundle size difference between PDF and SVG graphics is very trivial. However, there is a significant application bundle size increase when "Preserve Vector Data" option is enabled; PDFs have a bigger size increase than SVGs. The following bundle sizes are collected by using the asset catalog compiling tool directly on generated PDF and SVG imagesets from [Fluent icons repo](https://github.com/microsoft/fluentui-system-icons). There are 7702 imagesets in total at the time of the size analysis.

| Image Type | Assets.car Size (no vector data preserved) | Assets.car Size (vector data preserved) | Delta |
|--|--|--|--|
| PDF | 6,384,824 bytes (6.4 MB on disk) | 45,495,136 bytes (45.5 MB on disk) | +39,110,312 bytes (~39 MB), +612% |
| SVG | 6,386,488 bytes (6.4 MB on disk) | 18,037,888 bytes (18 MB on disk) | +11,651,400 bytes (~11 MB), +182% |

Note: the sizes above are built against a specific device type, so App Thinning is taken into account.

## Runtime Performance Impact
There's no measurable runtime performance difference between "Preserve Vector Data" turned on and off when the image is drawn at intrinsic size. However, drawing an image with "Preserve Vector Data" enabled is much slower when the image is stretched; stretched SVG images have a slightly better performance than stretched PDF images. The following data is collected by time profiling drawing 1000 images all at the same time on screen.

| | PDF w/o vector data preserved | SVG w/o vector data preserved | PDF with vector data preserved | SVG with vector data preserved |
|--|--|--|--|--|
| Intrinsic Size | 233 | 233.6 | 235.3 | 233.3 |
| Stretched | 101.3 | 102.6 | 433.3 | 402.7 |

### Methodology
The time profiling was done on a physical device with Xcode Instruments' Time Profiler tool measuring the time it takes for `CA::Transaction::Commit()` to complete after initiating the drawing of 1000 images.
