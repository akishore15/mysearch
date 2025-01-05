#!/bin/bash

# Install TypeScript if not already installed
npm install -g typescript

# Compile JavaScript to TypeScript
tsc search.js --outFile search.ts
