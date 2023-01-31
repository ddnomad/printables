Printables Monorepo
===================

![GitHub last commit](https://img.shields.io/github/last-commit/ddnomad/printables)
![GitHub commit activity](https://img.shields.io/github/commit-activity/w/ddnomad/printables)

This repository contains various models for printing with a 3D printer of your choice. All models are created using [OpenSCAD](https://openscad.org) with source code tracked in this repository.

Models
------

| Name | Version | Description | Path |
| ---- | ------- | ----------- | ---- |
| Dell T420 5.25" Bay Drive Bracket | v0.1.0 | A model that allows to mount four 2.5" drives inside [Dell T420](https://www.dell.com/support/home/en-ae/product-support/product/poweredge-t420) 5.25" bay blank. | [./models/dell_t420_525_bay_drive_bracket](./models/dell_t420_525_bay_drive_bracket) |
| Ikea Satsumas Pot | v0.1.0 | A crude model of a plant pot compatible with [Ikea Satsumas plant stand](https://www.ikea.com/gb/en/p/satsumas-plant-stand-with-5-plant-pots-bamboo-white-10258155/)  (article number `102.581.55`). | [./models/ikea_satsumas_pot](./models/ikea_satsumas_pot) |

Development
-----------

To work on this project, the following tools are required:

1. [Cargo Make](https://sagiegurari.github.io/cargo-make/)
2. [OpenSCAD](https://openscad.org)
3. [Python](https://www.python.org)

And the following tools are recommended:

1. [OpenSCAD Support for VS Code](https://github.com/Leathong/openscad-support-vscode)
2. [PyLama](https://github.com/klen/pylama)
3. [MarkdownLint](https://github.com/DavidAnson/markdownlint)

After cloning the project, run the following to integrate Git hooks:

```shell
cargo make init_git_hooks
```
