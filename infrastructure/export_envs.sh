#!/bin/bash

# Load environment variables from .env
export $(grep -v '^#' .env | xargs)