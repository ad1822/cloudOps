#!/bin/bash

cd ..
terraform graph > graph.dot
dot -Tpng graph.dot -o graph.png
