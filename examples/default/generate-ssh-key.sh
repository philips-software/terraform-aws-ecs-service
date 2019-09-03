#!/bin/bash

mkdir -p generated
ssh-keygen -t rsa -C "test-forest" -P '' -f generated/id_rsa
