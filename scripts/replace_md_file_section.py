#!/usr/bin/env python3
"""Replace a section in Markdown file with text from STDIN."""
import argparse
import os
import re
import sys
import typing as t

MARKDOWN_HEADER_RE = re.compile(r'((?:^(?:#{1,6})\s*.+$)|(?:^.+$\n^[=-]+$))', re.MULTILINE)


def check_file_exists(path: str, error: t.Optional[Exception] = None) -> str:
    """."""
    if not os.path.isfile(path):
        raise error if error else ValueError(f'Invalid file path: {path}')

    return os.path.abspath(path)


def get_markdown_sections(md_document: str) -> list[tuple[str, str]]:
    """."""
    md_sections = list(filter(lambda s: s.strip(), MARKDOWN_HEADER_RE.split(md_document)))

    if len(md_sections) % 2 != 0 or len(md_sections) < 2:
        raise ValueError('Failed to split Markdown document into sections')

    return zip(md_sections[0::2], md_sections[1::2])  # type: ignore


def main(args: argparse.Namespace):
    """."""
    with open(args.md_file_path, 'r', encoding='utf8') as f:
        md_document = f.read()

    md_sections = get_markdown_sections(md_document)

    edited_md_document = ''

    for md_header, md_section in md_sections:
        md_header_text = md_header.splitlines()[0].lstrip('#')

        if md_header_text == args.section_name:
            md_section = f'\n\n{sys.stdin.read()}\n'

        edited_md_document += f'{md_header}{md_section}'

    with open(args.md_file_path, 'w', encoding='utf8') as f:
        f.write(edited_md_document)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument(
        'md_file_path',
        help='path to a Markdown file to modify',
        metavar='MD_FILE_PATH',
        type=lambda value: check_file_exists(
            value,
            error=argparse.ArgumentTypeError('Markdown file does not exist or is not a regular file')
        )
    )
    parser.add_argument('section_name', help='name of Markdown section to replace', metavar='MD_SECTION_NAME')

    main(parser.parse_args())
