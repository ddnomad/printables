#!/usr/bin/env python3
"""Generate a markdown table with information about all OpenSCAD models in a given directory."""
import argparse
import collections
import glob
import os
import re
import typing as t

MODEL_DESCRIPTION_RE = re.compile(r'(?:\w\s*)+\n=+\n\n?(.+)\n\n?.*', re.MULTILINE)
MODEL_NAME_RE = re.compile(r'^\s*MODEL_NAME\s*=\s*\"(.+)\"\s*;\s*$', re.MULTILINE)
MODEL_VERSION_RE = re.compile(r'^\s*MODEL_VERSION\s*=\s*\"([A-Za-z0-9._-]+)\"\s*;\s*$', re.MULTILINE)

OpenSCADModel = collections.namedtuple('OpenSCADModel', ['name', 'version', 'description', 'directory_path'])


def check_directory_exists(path: str, error: t.Optional[Exception] = None) -> str:
    """."""
    if not os.path.isdir(path):
        raise error if error else ValueError(f'Invalid directory path: {path}')

    return os.path.abspath(path)


def find_first(regex: re.Pattern, text: str, group_number: int, error: t.Optional[Exception] = None) -> str:
    """."""
    match = regex.search(text)

    if not match:
        raise error if error else ValueError('Failed to find a match')

    return match.group(group_number)


def find_models(path: str) -> t.Generator[OpenSCADModel, None, None]:
    """."""
    for model_main_path in glob.glob(os.path.join(path, '**/main.scad'), recursive=True):
        with open(model_main_path, 'r', encoding='utf8') as f:
            model_main_source = f.read()

        model_name = find_first(MODEL_NAME_RE, model_main_source, 1, RuntimeError(
            f'Failed to parse out model name: model_main_path: {model_main_path}'
        ))
        model_name = model_name.replace('\\', '')

        model_version = find_first(MODEL_VERSION_RE, model_main_source, 1, RuntimeError(
            f'Failed to parse out model version: model_main_path: {model_main_path}'
        ))

        model_dir_path = os.path.dirname(model_main_path)

        model_readme_path = os.path.join(model_dir_path, 'README.md')
        if not os.path.isfile(model_readme_path):
            raise RuntimeError(f'Failed to locate model README file: {model_readme_path}')

        with open(model_readme_path, 'r', encoding='utf8') as f:
            model_readme = f.read()

        model_description = find_first(MODEL_DESCRIPTION_RE, model_readme, 1, RuntimeError(
            f'Failed to parse out model description: model_main_path: {model_main_path}'
        ))

        yield OpenSCADModel(model_name, model_version, model_description, model_dir_path)


def main(args: argparse.Namespace):
    """."""
    print('| Name | Version | Description | Path |')
    print('| ---- | ------- | ----------- | ---- |')

    for model in find_models(args.models_dir_path):
        relative_model_path = './' + os.path.relpath(model.directory_path)

        print(
            f'| {model.name} | v{model.version} | {model.description} | '
            f'[{relative_model_path}]({relative_model_path}) |'
        )


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument(
        'models_dir_path',
        help='path to a directory containing target OpenSCAD models',
        metavar='MODELS_DIR_PATH',
        type=lambda value: check_directory_exists(
            value,
            error=argparse.ArgumentTypeError('Models directory path does not exist or is not a directory')
        )
    )

    main(parser.parse_args())
