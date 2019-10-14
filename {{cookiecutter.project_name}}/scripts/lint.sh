#!/bin/bash
set -euxo pipefail


pyversion=$(python3 -V 2>&1 | sed 's/.* \([0-9]\).\([0-9]\).*/\1\2/')

if [[ "$pyversion" -lt "36" ]]
then
    echo "WARNING: Some linters have been skipped. Run against 3.6+ for full set of linters to run against the project!"
else
    poetry run cruft check
    poetry run mypy --ignore-missing-imports {{cookiecutter.project_name}}/
    poetry run black --check -l 100 {{cookiecutter.project_name}}/ tests/
fi

poetry run isort --multi-line=3 --trailing-comma --force-grid-wrap=0 --use-parentheses --line-width=100 --recursive --check --diff --recursive {{cookiecutter.project_name}}/ tests/
poetry run flake8 {{cookiecutter.project_name}}/ tests/ --max-line 100 --ignore F403,F401,W503,E203
poetry run safety check
poetry run bandit -r {{cookiecutter.project_name}}/
