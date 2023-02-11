Printables Monorepo
===================

![GitHub last commit](https://img.shields.io/github/last-commit/ddnomad/printables)
![GitHub commit activity](https://img.shields.io/github/commit-activity/w/ddnomad/printables)
![GitHub release workflow status](https://img.shields.io/github/actions/workflow/status/ddnomad/printables/release.yml)

This repository contains various models for 3D printing created using [OpenSCAD](https://openscad.org).

Models that are deemed "good enough" will be also published on [printables.com](https://www.printables.com/social/553630-ddnomad/models) and created as a separate release in this repository. If a particular model is not yet published/released, it is probably still work in progress.

Models
------

| Name | Version | Description | Details |
| ---- | ------- | ----------- | ------- |
| Dell T420 5.25" Bay Drive Bracket | v0.1.2 | A model that allows to mount three 2.5" SATA SSD drives (e.g. [Samsung 870 EVO](https://www.samsung.com/uk/memory-storage/sata-ssd/870-evo-1tb-sata-3-2-5-ssd-mz-77e1t0b-eu/)) inside [Dell T420](https://www.dell.com/support/home/en-ae/product-support/product/poweredge-t420) 5.25" bay blank (also works for [Dell T620](https://www.dell.com/support/home/en-ae/product-support/product/poweredge-t620)). | [Details](./models/dell_t420_525_bay_drive_bracket) |
| Ikea Satsumas Pot | v0.1.0 | A crude model of a plant pot compatible with [Ikea Satsumas plant stand](https://www.ikea.com/gb/en/p/satsumas-plant-stand-with-5-plant-pots-bamboo-white-10258155/)  (article number `102.581.55`). | [Details](./models/ikea_satsumas_pot) |

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
makers init_git_hooks
```
