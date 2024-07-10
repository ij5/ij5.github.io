---
title: Google Gemini API 사용하기
date: 2024-07-10
tags:
- API
- AI
- Gemini
- LLM
authors:
- 이재희
slug: using-google-gemini-api
draft: false
---

# 개요

나는 최근 로컬 LLM에 대한 흥미를 잃고 있다. 
*왜 굳이 로컬 LLM을 사용할까?*
무료이기 때문이다. 로컬 리소스만 사용하여 모델을 무료로 계속 돌릴 수 있다는 장점과 어떠한 정보가 타 기업에게 넘어가는 사태를 방지하기 위한 점이 가장 크다고 생각한다. 

하지만 나는 기업도 아니고, LLM이 추론한 결과가 구글에 넘어가도 아무런 상관이 없다. 게다가 나는 로컬 리소스도 그렇게 널널하지 않은 편이다.
이러한 이유로 인해 (미래에는 어떨지 모르지만) 온디바이스 LLM을 굳이 고집해야 할까? 라는 회의감도 들어서 발견한 것이 구글의 AI Studio이다.

킹구글은 명성에 맞게 Gemini API를 사용량 제한 무료로 공개하였다. 사실 공개한지는 꽤 됐다.

gemini-1.5-flash 모델 기준으로 무료 계정의 제한은 다음과 같다.

* 1분 당 요청 15개 (requests per minute, RPM)
* 1분 당 100만 토큰 (tokens per minute, TPM)
* 1일 당 1,500 요청 (requests per day, RPD)
  눈에 띄는 것은 `Data used to improve our product`라고 쓰여있는 부분이다. 무료 계정은 생성한 데이터가 구글로 전송된다는 뜻인 듯하다.

그런데 gemini-1.5-flash 모델을 사용해 보니 성능이 꽤 괜찮다고 느꼈다. 추론 속도도 빠르고, 생성 퀄리티도 좋은 것 같다.

# 생성형 AI 라이브러리

구글의 AI Studio는 지원하는 언어도 다양하다. 현재 작성일을 기준으로 공식 라이브러리가 구현된 언어는  다음과 같다.

````diff
+ Python
+ Node.js
+ Web
+ REST
+ Go
+ Dart (Flutter)
+ Android
+ Swift
````

웬만한 언어들은 API 키만 있다면 바로 편리하게 사용할 수 있다.

나는 파이썬 라이브러리를 사용할 건데, 다음 명령어로 설치할 수 있다.

````bash
$ pip install -q -U google-generativeai
````

사용도 쉽다.

````python
import google.generativeai as genai
genai.configure(api_key="<APIKEY>")

model = genai.GenerativeModel('gemini-1.5-flash')

response = model.generate_content("삶의 의미가 무엇일까?")
print(response.text)
````

# 마치며

공식문서가 잘 되어있어 사용하는 데 큰 지장은 없을 것 같다.

앞으로도 무료로 api를 제공해줬으면 좋겠다고 생각했다. 

바이루
