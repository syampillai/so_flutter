#!/bin/bash

dart analyze lib/*
dart format .
flutter pub publish --dry-run

