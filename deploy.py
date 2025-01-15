#!/usr/bin/env python3

import os
import sys
from enum import Enum
from pathlib import Path
import shutil


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
    print("    -f, --force          Force update no matter what")
    print("    -h, --help           Print help only")
    print()
    print("Manifest format:")
    print("    <config>|<operation>|<destination>")
    print(f"    config: relative path from {SCRIPT_DIR}")
    print("    operation: symlink|copy|extract")
    print(f"    destination: relative path from {HOME}. Can be empty")


def remove_item(path):
    if os.path.islink(path):
        os.unlink(path)
    elif os.path.isfile(path):
        os.remove(path)
    elif os.path.isdir(path):
        shutil.rmtree(path)
    else:
        raise Exception("Not supported item type")


def copy_item(source, destination):
    if os.path.isfile(source):
        shutil.copy(source, destination)
    elif os.path.isdir(source):
        shutil.copytree(source, destination)
    else:
        raise Exception("Not supported item type")


def backup_and_rename(path):
    backup = f"{path}_old"
    if os.path.exists(backup):
        print_log(LogLevel.DEBUG, f"Remove: {backup}")
        remove_item(backup)

    print_log(LogLevel.DEBUG, f"Rename: {path} -> {backup}")
    shutil.move(path, backup)


def handle_existing_item(source, destination, force):
    if os.path.islink(destination):
        target = os.path.realpath(destination)
        if target == source:
            print_log(LogLevel.INFO, f"Already linked {destination} -> {source}")
            return True

        if not force:
            raise Exception(f"Linked to another target: {target}")

        print_log(LogLevel.WARN, f"Force unlink: {destination}")
        remove_item(destination)

    elif os.path.exists(destination):
        if force:
            print_log(LogLevel.WARN, f"Force remove: {destination}")
            remove_item(destination)
        else:
            backup_and_rename(destination)

    return False


# -------------------- CORE --------------------------


# Case 1: {destination} not existed -> create link {source}
# Case 2: {destination} is an existed symlink
#           - Already linked to {source} -> ignore
#           - Linked to other target
#               + force     -> unlink and relink to {source}
#               + no force  -> throw
# Case 3: {destination} is an existing file
#           - force     -> remove file and create link to {source}
#           - no force  -> backup and create line to {source}
# Case 4: {destination} is an existing directory
#           - force     -> remove file
#           - no force  -> backup and create line to {source}


def make_symlink(source, destination, force=False):
    if not os.path.exists(source):
        raise ManifestError(f'Invalid source "{source}"')

    try:
        destination_parent = Path(os.path.dirname(destination))
        destination_parent.mkdir(parents=True, exist_ok=True)

        if os.path.islink(destination):
            target = os.path.realpath(destination)
            if target == source:
                print_log(LogLevel.INFO, f"Already linked {destination} -> {source}")
                return

            if not force:
                raise Exception(f"Linked to other target")

            print_log(LogLevel.WARN, f"Force unlink: {destination}")
            remove_item(destination)

        elif os.path.exists(destination):
            if force:
                print_log(LogLevel.WARN, f"Force remove: {destination}")
                remove_item(destination)
            else:
                backup_and_rename(destination)

        os.symlink(source, destination)
        print_log(LogLevel.OK, f"Linked: {destination} -> {source}")

    except Exception as e:
        raise ProcessingError(str(e))


def make_copy(source, destination, force=False):
    if not os.path.exists(source):
        raise ManifestError(f'Invalid source "{source}"')

    try:
        if os.path.islink(destination):
            target = os.path.realpath(destination)
            if os.path.isfile(target):
                if force:
                    print_log(LogLevel.WARN, f"Force unlink: {destination}")
                    remove_item(destination)
                else:
                    raise Exception("Linked to other file")

        elif os.path.isfile(destination):
            if force:
                print_log(LogLevel.WARN, f"Force remove: {destination}")
                remove_item(destination)
            else:
                destination_backup = f"{destination}_old"
                if os.path.exists(destination_backup):
                    print_log(LogLevel.DEBUG, f"Remove: {destination_backup}")
                    remove_item(destination_backup)

                print_log(
                    LogLevel.DEBUG, f"Rename: {destination} -> {destination_backup}"
                )
                shutil.move(destination, destination_backup)

        copy_item(source, destination)
        print_log(LogLevel.OK, f"Copied: {source} -> {destination}")
    except Exception as e:
        raise ProcessingError(str(e))


def process(line, force=False):
    parts = line.split("|")
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
                print_log(LogLevel.WARN, f"Skip processing line {line}: {str(e)}")
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

    if file_name == None:
        raise ArgumentError("Missing file name")

    parse_manifest(file_name, force)


# ------------------- MAIN SCRIPT ---------------------------


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print_log(LogLevel.ERROR, str(e))
