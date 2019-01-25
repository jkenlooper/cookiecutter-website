#!/usr/bin/env bash
set -eu -o pipefail

journalctl --follow \
  _SYSTEMD_UNIT={{ cookiecutter.project_slug }}-chill.service \
  _SYSTEMD_UNIT={{ cookiecutter.project_slug }}-api.service

