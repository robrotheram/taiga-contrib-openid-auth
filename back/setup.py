#!/usr/bin/env python
# -*- coding: utf-8 -*-

import versiontools_support
from setuptools import setup, find_packages

setup(
    name = 'taiga-contrib-openid-auth',
    version = ":versiontools:taiga_contrib_openid_auth:",
    description = "The Taiga plugin for openid authentication",
    long_description = "",
    keywords = 'taiga, openid, auth, plugin',
    author = 'Robert Fletcher',
    url = 'https://github.com/robrotheran/taiga-contrib-openid-auth',
    license = 'AGPL',
    include_package_data = True,
    packages = find_packages(),
    install_requires=[],
    setup_requires = [
        'versiontools >= 1.9',
    ],
    classifiers = [
        "Programming Language :: Python",
        'Development Status :: 4 - Beta',
        'Framework :: Django',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: GNU Affero General Public License v3',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Topic :: Internet :: WWW/HTTP',
    ]
)
