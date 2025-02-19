#!/bin/bash -e

base_dir=$(dirname $(dirname $0))
targets="${base_dir}/*.py ${base_dir}/examples/ ${base_dir}/keras_nlp/"

isort --sp "${base_dir}/setup.cfg" --sl -c ${targets}
if ! [ $? -eq 0 ]; then
  echo "Please run \"./shell/format.sh\" to format the code."
  exit 1
fi

flake8 --config "${base_dir}/setup.cfg" --max-line-length=200 ${targets}
if ! [ $? -eq 0 ]; then
  echo "Please fix the code style issue."
  exit 1
fi

black --check --line-length 80 ${targets}
if ! [ $? -eq 0 ]; then
  echo "Please run \"./shell/format.sh\" to format the code."
    exit 1
fi
for i in $(find ${targets} -name '*.py'); do
  if ! grep -q Copyright $i; then
    echo "Please run \"./shell/format.sh\" to format the code."
    exit 1
  fi
done
