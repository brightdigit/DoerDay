#!/bin/sh

echo "// swift-tools-version: 5.9" > Package.swift
cat Package/Support/*.swift >> Package.swift
cat Package/Sources/**/*.swift >> Package.swift
cat Package/Sources/*.swift >> Package.swift
