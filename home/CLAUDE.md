# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a practice workspace used for learning Claude Code slash commands via the claude-code-tutorial skill.

## Python 생태계 관습

Python 작업 중 생태계 관습(네이밍, 패키징, 프로젝트 구조, 도구 사용법 등)을 발견하면 `python-ecosystem.md`에 기록할 것. 기존 항목과 중복되지 않도록 먼저 확인 후 추가.

## GitHub 지식

GitHub 관련 문화, 제공 서비스, 기능(Actions, Secrets, Fork 등)을 학습하면 `github-knowledge.md`에 기록할 것. 기존 항목과 중복되지 않도록 먼저 확인 후 추가.

## Swift 지식

Swift/SwiftUI 작업 중 플랫폼 제약, 동시성 패턴 등 경험적 지식을 발견하면 `swift-knowledge.md`에 기록할 것. 기존 항목과 중복되지 않도록 먼저 확인 후 추가.

## Next.js 지식

Next.js/TypeScript 작업 중 프레임워크 관례, 패턴 등 경험적 지식을 발견하면 `nextjs-knowledge.md`에 기록할 것. 기존 항목과 중복되지 않도록 먼저 확인 후 추가.

## Claude Code Skills/Commands 지식

Claude Code 스킬/커맨드 저작 중 발견한 경험적 지식(사용 가능한 도구, UI 패턴, frontmatter, cmux 연동 등)을 `claude-code-skills-knowledge.md`에 기록할 것. 기존 항목과 중복되지 않도록 먼저 확인 후 추가.

## UI/Frontend Workflow

- CSS/레이아웃 수정 시 **반드시 Playwright MCP 스크린샷으로 결과 확인 후 커밋**. 추측만으로 CSS를 수정하지 말 것.
- 복잡한 UI 컴포넌트 개선 요청 시 `mcp__magic__21st_magic_component_refiner`를 먼저 활용하여 검증된 패턴 참조.

## Sensitive Issue Management

민감한 내용(경쟁 분석, 내부 전략, 비공개 판단 등)은 public repo 이슈에 작성하지 말 것.
`internal-notes` private repo에 이슈로 생성하고, `repo:<name>` 라벨로 출처 구분.
public repo 이슈에서는 실행 기록만 남기고 하단에 internal-notes 참조 표기.

## API Keys

API 키 정보는 `.claude/keys.md` 파일 참조 (gitignore 처리됨).

## Config Sync

이 디렉토리의 설정 및 지식 파일은 `~/home/claude-config` 레포를 통해 동기화된다.

- 새 파일을 추가하거나 기존 파일이 이 CLAUDE.md에서 참조될 경우, `claude-config/sync.sh`의 `SYNC_PAIRS`에도 등록해야 한다. 등록 후 `./sync.sh setup` 실행하여 hook 재설치 필요.
- 작업 중 반복되는 주제의 지식이 축적되고 있다고 판단되면, 새 지식 파일(예: `docker-knowledge.md`) 생성을 사용자에게 제안할 것. 최종 결정은 사용자가 한다.
