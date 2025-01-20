#!/usr/bin/env python3

import os
import sys
import shutil
import zipfile
import tarfile
from enum import Enum
from pathlib import Path


# ------------------- DEFINITIONS ---------------------------


class LogLevel(Enum):
    DEBUG = 0
    INFO = 1
    WARN = 2
    ERROR = 3
    OK = 4

    def __str__(self):
        return self.name

    def __int__(self):
        return self.value


class ArgumentError(Exception): ...


class ManifestError(Exception): ...


class ManifestFileError(Exception):
    def __init__(self, message, line_number, line_data):
        self.message = f"{message} on line {line_number}: {line_data}"
        super().__init__(self.message)


class ManifestFileNotFoundError(Exception):
    def __init__(self, file_name):
        self.message = f"Manifest file not found: {file_name}"
        super().__init__(self.message)


class ProcessingError(Exception): ...


# -------------------- GLOBAL --------------------------


SCRIPT_NAME = os.path.basename(__file__)
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
HOME = os.path.expanduser("~")
LOG_LEVEL = LogLevel.DEBUG


# -------------------- UTILITIES --------------------------


def print_log(level, message):
    if int(level) >= int(LOG_LEVEL):
        level_tag = f"[{str(level)}]"
        print(f"{level_tag:<8} {message}")


def print_help():
    print(f"Usage: ./{SCRIPT_NAME} [OPTION] <MANIFEST FILE>")
    print()
    print("Options:")
    print("    -f, --force          Force process manifest command")
    print("    -h, --help           Print help only")
    print()
    print("Manifest format:")
    print("    <operation>|<source>|<destination>")
    print(f"    operation: symlink|copy|extract")
    print(f"    source: relative path from {SCRIPT_DIR}")
    print(f"    destination: relative path from {HOME}. Can be empty")


def remove_item(path):
    if os.path.islink(path):
        os.unlink(path)
        print_log(LogLevel.DEBUG, f"Unlinked: {path}")
    elif os.path.isfile(path):
        os.remove(path)
        print_log(LogLevel.DEBUG, f"Remove file: {path}")
    elif os.path.isdir(path):
        shutil.rmtree(path)
        print_log(LogLevel.DEBUG, f"Remove directory: {path}")
    else:
        raise Exception("Not supported item type")


def copy_item(source, destination):
    if os.path.exists(destination):
        raise Exception("Destination still existed.")

    if os.path.isfile(source):
        shutil.copy(source, destination)
    elif os.path.isdir(source):
        shutil.copytree(source, destination)
    else:
        raise Exception("Not supported item type.")


def check_linked(source, destination) -> bool:
    return os.path.realpath(destination) == source


def remove_or_backup(path):
    if not os.path.exists(path):
        raise Exception(f"{path} not found")

    if os.path.islink(path):
        remove_item(path)

    elif os.path.isdir(path) or os.path.isfile(path):
        backup = f"{path}_old"
        if os.path.exists(backup):
            remove_item(backup)

        shutil.move(path, backup)
        print_log(LogLevel.DEBUG, f"Renamed: {path} -> {backup}")

    else:
        raise Exception("Not supported item type.")


def extract_archive(archive_path, output_dir):
    if archive_path.endswith((".tar.gz", ".tar.bz2", ".tgz", ".tbz2", ".tar")):
        with tarfile.open(archive_path, "r:*") as tar:
            tar.extractall(path=output_dir, filter="tar")

    elif archive_path.endswith(".zip"):
        with zipfile.ZipFile(archive_path, "r") as zip_ref:
            zip_ref.extractall(output_dir)

    else:
        raise Exception("Unsupported archive format.")


# -------------------- CORE --------------------------


def make_symlink(source, destination, force=False):
    if not os.path.exists(source):
        raise ManifestError(f'Invalid source "{source}"')

    try:
        destination_parent = Path(os.path.dirname(destination))

        if not destination_parent.exists():
            if not force:
                raise Exception(f"{str(destination_parent)} not found.")

            destination_parent.mkdir(parents=True)

        else:
            if os.path.exists(destination):
                if os.path.islink(destination) and check_linked(source, destination):
                    raise Exception("Already linked.")

                if not force:
                    raise Exception("Destination existed.")

                remove_or_backup(destination)

        os.symlink(source, destination)
        print_log(LogLevel.OK, f"Linked: {destination} -> {source}")
    except Exception as e:
        raise ProcessingError(str(e))


def make_copy(source, destination, force=False):
    if not os.path.exists(source):
        raise ManifestError(f'Invalid source "{source}"')

    try:
        destination_parent = Path(os.path.dirname(destination))

        if not destination_parent.exists():
            if not force:
                raise Exception(f"{str(destination_parent)} not found.")

            destination_parent.mkdir(parents=True)

        else:
            if os.path.exists(destination):
                if not force:
                    raise Exception("Destination existed.")

                remove_or_backup(destination)

        copy_item(source, destination)
        print_log(LogLevel.OK, f"Copied: {source} -> {destination}")
    except Exception as e:
        raise ProcessingError(str(e))


def extract(archive_path, output_dir, force=False):
    if not os.path.exists(archive_path):
        raise ManifestError("Invalid archive path")

    try:
        destination = Path(output_dir)

        if not destination.exists():
            if not force:
                raise Exception("Output directory not found.")

            destination.mkdir(parents=True)

        else:
            if not destination.is_dir():
                if not force:
                    raise Exception("Extract location existed and not a directory.")

                remove_or_backup(output_dir)

        extract_archive(archive_path, output_dir)
        print_log(LogLevel.OK, f"Extracted: {archive_path} -> {output_dir}")
    except Exception as e:
        raise ProcessingError(str(e))


def process(line, force=False):
    parts = [part.strip() for part in line.split("#")[0].split("|")]

    if len(parts) != 3:
        raise ManifestError("Invalid format")

    operation, source, destination = parts

    if not operation:
        raise ManifestError('Missing "operation"')

    if not source:
        raise ManifestError('Missing "source"')

    source = os.path.join(SCRIPT_DIR, source)
    destination = os.path.join(HOME, destination)

    if operation == "symlink":
        make_symlink(source, destination, force)
    elif operation == "copy":
        make_copy(source, destination, force)
    elif operation == "extract":
        extract(source, destination, force)
    else:
        raise ManifestError(f'Unknown operation "{operation}"')


def parse_manifest(file_name, force=False):
    if not os.path.isfile(file_name):
        raise ManifestFileNotFoundError(file_name)

    with open(file_name, "r") as file:
        for line_num, line in enumerate(file, start=1):
            line = line.strip()
            if not line or line.startswith("#"):
                continue

            try:
                process(line, force)
            except ProcessingError as e:
                print_log(LogLevel.WARN, f"Skip processing line {line_num}: {str(e)}")
            except ManifestError as e:
                raise ManifestFileError(str(e), line_num, line)


def main():
    argv = sys.argv[1:]
    file_name = None
    force = False

    if len(argv) == 0 or "-h" in argv or "--help" in argv:
        print_help()
        return
    elif len(argv) > 2:
        raise ArgumentError("Too many argument")

    for arg in argv:
        if arg == "-f" or arg == "--force":
            force = True
        elif arg.startswith("-"):
            raise ArgumentError(f"Unknown argument: {arg}")
        else:
            file_name = arg

    if not file_name:
        raise ArgumentError("Missing file name")

    parse_manifest(file_name, force)


# ------------------- MAIN SCRIPT ---------------------------


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print_log(LogLevel.ERROR, str(e))
