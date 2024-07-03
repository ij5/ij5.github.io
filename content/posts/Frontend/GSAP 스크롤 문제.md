---
title: GSAP 스크롤 애니메이션 오류 해결
date: 2024-07-03
tags:
- GSAP
- Javascript
- Typescript
- Frontend
authors:
- 이재희
slug: fixing-gsap-scroll-animation
draft: false
---

# 흠

최근 랜딩 페이지를 만들고 있는데, 이런 유형의 홈페이지를 많이 만들어보지 못해서 2~3일 간 뻘짓하다 시간을 날렸다. 개인적으로 GSAP(GreenSock Animation Platform)라는 라이브러리가 애니메이션 관련 작업하기에 최고라고 생각해서 바로 프로젝트에 적용하다가, 사용법 미숙으로 인해 삽질만 하다가 하루가 증발했다. 

# 무엇이 문제인가

랜딩 페이지에서 각 section별로 스크롤 시 배경 화면 색깔이 달라지게 구현을 하고 싶었다. 무작정 만들어본 구현 코드는 다음과 같다.

````typescript
let currentGradient = "linear-gradient(120deg, #4facfe 0%, #00f2fe 100%)";
function registerBackground(id: string, gradient: string) {
  gsap.to("#background", {
    backgroundImage: gradient,
    scrollTrigger: {
      trigger: id,
      start: "top bottom",
      end: 'top top',
      scrub: true
    },
  });
  currentGradient = gradient;
}
````

여기서 `registerBackground` 함수를 다음과 같이 호출하면...

````typescript
registerBackground('#intro', "linear-gradient(120deg, #f093fb 0%, #f5576c 100%)");
registerBackground('#second', "linear-gradient(120deg, #c1dfc4 0%, #deecdd 100%)")
````

이렇게 각 부분별로 배경색을 다르게 지정할 수 있게 된다.

실제로 스크롤을 해 보면 첫 번째로 호출한 함수까지는 예상대로 작동을 한다.
그런데! 두 번째 영역(second)로 스크롤을 해보면 배경색이 초기값으로 바뀌어버리는 문제가 발생한다.
예를 들어, 검정 -> 빨강 -> 파랑 순으로 바뀌어야 정상인데 검정 -> 빨강 -> 검정 -> 파랑 순으로 색이 변경된다.

# 해결 방법

해결 방법은 간단하다.

````typescript
gsap.set("#background", {
  backgroundImage: currentGradient,
});
````

먼저 gsap.set 메소드를 통해 초기값을 설정해줘야 한다.

**마지막으로 `gsap.to` 부분에 `immediateRender: false` 옵션도 추가가 필요하다.**

````typescript
gsap.to("#bgsap.to("#background", {
  backgroundImage: gradient,
  immediateRender: false,
  scrollTrigger: {
    trigger: id,
    start: "top bottom",
    end: 'top top',
    scrub: true
  },
});
````

# 오늘 배운 것

설명서(공식 문서)를 잘 읽자.
