#!/usr/bin/env python

""" Setup for obs2r """

from glob import glob
from setuptools import find_packages, setup
from os.path import basename, dirname, realpath

def main():
    return setup(
        author='Sijin Zhang',
        author_email='Sijin.Zhang@metservice.com',
        data_files=[('gsi_stuff/etc', glob('etc/*')), ('gsi_stuff/script', glob('script/*'))],
        description='Script for running GSI',
        maintainer='Sijin Zhang',
        maintainer_email='Sijin.Zhang@metservice.com',
        # Use name of the directory as name
        name=basename(dirname(realpath(__file__))),
        packages=find_packages(),
        zip_safe=False
    )


if __name__ == '__main__':
    main()
