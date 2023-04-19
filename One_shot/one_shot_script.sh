#!/bin/sh

TEST=$(grep -Po '(?<=\[Region\] : ")[^"]*' ./setup.config)
