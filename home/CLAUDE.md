# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a practice workspace used for learning Claude Code slash commands via the claude-code-tutorial skill.

## Python 생태계 관습

Python 작업 중 생태계 관습(네이밍, 패키징, 프로젝트 구조, 도구 사용법 등)을 발견하면 `python-ecosystem.md`에 기록할 것. 기존 항목과 중복되지 않도록 먼저 확인 후 추가.

## GitHub 지식

GitHub 관련 문화, 제공 서비스, 기능(Actions, Secrets, Fork 등)을 학습하면 `github-knowledge.md`에 기록할 것. 기존 항목과 중복되지 않도록 먼저 확인 후 추가.

## API Keys

API 키 정보는 `.claude/keys.md` 파일 참조 (gitignore 처리됨).

## Config Sync

이 디렉토리의 설정 및 지식 파일은 `~/home/claude-config` 레포를 통해 동기화된다. 새 파일을 추가하거나 기존 파일이 이 CLAUDE.md에서 참조될 경우, `claude-config/sync.sh`의 `SYNC_PAIRS`에도 등록해야 한다. 등록 후 `./sync.sh setup` 실행하여 hook 재설치 필요.
