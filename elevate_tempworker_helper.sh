#!/usr/bin/env bash

su yourboss -c echo "tempworker ALL=(ALL:ALL) ALL" | sudo EDITOR="tee -a" visudo
