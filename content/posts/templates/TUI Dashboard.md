---
title: Terminal UI Dashboard with RustPython
date: 2024-06-05
tags:
- TUI
- Ratatui
- Rust
- Terminal
- Console
- Python
- RustPython
authors:
- 이재희
slug: tui-dashboard
---

# 개요

예전부터 대시보드 같은 프로그램이 굉장히 멋져보였다. 그래서 한번 구축해보려고 쓸만한 대시보드를 찾다가, 마음에 드는게 없어 직접 만들어보자고 결심했다. 내가 원하는 건 간단하게 위젯을 추가할 수 있고, 빠르며, 직관적인 터미널 UI 대시보드였다. 

# 사용 언어, 라이브러리

* Rust
  * **ratatui**: ratatui라는 터미널 UI 라이브러리가 있는데, TUI 라이브러리 중 이게 가장 유명한 듯하여 사용하였다. 라따뚜이~
  * **tokio**: 비동기 라이브러리. 필수 필수 필수
  * **tokio-tungstenite**: 웹소켓 관련
  * **serde_json**: JSON 형식 지원
  * ... 이하 생략
  * 라이브러리를 이것저것 설치하다보니 target 폴더가 10GB를 찍었다.
* Python
  * 기본 라이브러리
  * 파이썬의 Rust 구현체 사용

# 나의 계획
