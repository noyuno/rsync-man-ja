#!/bin/bash -e

pandoc -t man man.md -s | man -l -

