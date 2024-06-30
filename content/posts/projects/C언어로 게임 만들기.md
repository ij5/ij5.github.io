---
title: C언어로 게임 만들기
date: 2024-06-30
tags:
- C
- Game
- Raylib
authors:
- 이재희
slug: make-a-game-with-c
draft: false
---

# 동기

C언어 수업을 마치고, 어떤 주제로 기말 과제를 할지 고민하다가 언어의 이해도를 높이려면 직접 프로그램을 만들어봐야 한다고 생각했다. 
마침 raylib이라는 크로스 플랫폼 게임 엔진을 발견하게 되어 게임을 만들어보자고 결정했다.

# Raylib?

Raylib는 크로스 플랫폼 게임 라이브러리로, C언어로 작성되어 여러 프로그래밍 언어에 바인딩 할 수 있고 윈도우부터 웹까지 다양한 플랫폼에서 실행이 가능하다는 장점을 가지고 있다. 
이 라이브러리가 제공하는 API 등이 직관적이라서 사용하기 쉽고 편하다고 느꼈다.
또한 게임을 만들 때 필수로 쓰이는 웬만한 함수들은 전부 구현이 되어있었다. (ex. Collision 관련 함수)
특히 외부 종속성이 없는 점이 마음에 들었다.

# Prerequisites

## Windows

윈도우에서 raylib를 컴파일 하려면 [w64devkit](https://github.com/skeeto/w64devkit) 개발환경을 사용하거나  [Itch](https://raysan5.itch.io/raylib)에서 다운로드 후, 원클릭으로 바로 설치할 수 있다. 나는 설치 프로그램이 따로 있는 줄 모르고 [깃허브 프로젝트 위키](https://github.com/raysan5/raylib/wiki/Working-on-Windows)를 참고하여 삽질을 좀 했다. 


# 게임 기획

![](https://i.imgur.com/t0v4zmm.png)

나는 2000년대 초반 누군가가 개발했던 **똥피하기 온라인**을 처음부터 다시 구현하기로 했다. 똑같이 구현하는 게 목표이므로 플레이어 등 이미지 파일만 필요하기 때문에 해당 게임의 exe 파일에서 스프라이트 에셋만 추출하였다.

원본을 직접 플레이 해보면 알겠지만, 플레이어가 그냥 움직이는 것이 아니라 얼음판 위를 뛰어다니듯이 스무스하게 움직이고 벽에 부딪히면 튕겨져나오는 방식으로 만들어놨기 때문에 이 부분이 조금 어려웠다.

# 헤더 파일

````c
// main.c
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "raylib.h"
````

raylib 설치 후, 메인 파일 최상단에 위와 같이 헤더 파일을 포함시켜준다. IDE에 따라 raylib.h를 찾을 수 없다고 나오는 경우가 있는데, 나는 vscode의 C/C++ Extension에서 includePath 부분을 수정하여 해결했다.

raylib는 저렇게 헤더 파일 하나만 include 해주면 바로 사용이 가능하다.

# 에셋 불러오기

````c
// embed.c
int main(void)
{
    Image ddon = LoadImage("assets/ddon.png");
    ExportImageAsCode(ddon, "ddon.h");
    Image human = LoadImage("assets/human.png");
    ExportImageAsCode(human, "human.h");
    Image blue = LoadImage("assets/bluehuman.png");
    ExportImageAsCode(human, "bluehuman.h");

    return 0;
}
````

나중에 게임을 배포할 때 이미지 파일까지 폴더에 넣어서 배포할 수는 없으니 raylib에서 제공하는 함수들을 이용해 에셋을 헤더 파일로 변환했다. 변환된 헤더 파일은 다음과 같은 형식으로 구성되어 있다.

````c
// ddon.h
// Image data information
#define DDON_WIDTH    20
#define DDON_HEIGHT   17
#define DDON_FORMAT   7          // raylib internal pixel format

static unsigned char DDON_DATA[1360] = { 0xff,
0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
... (이하 생략)
````

이렇게 바이트 배열로 생성이 된다. 

# main.c

````c
// main.c

typedef enum PlayerState
{
    IDLE,
    LEFT,
    RIGHT,
    DEAD,
} PlayerState;

typedef struct Player
{
    Vector2 pos;
    float textureWidth;
    float textureHeight;
    Rectangle sprite;
    Rectangle rec;
    Texture2D *texture;
    PlayerState state;
    double velocity;
    int frame;
} Player;

typedef struct Obstacle
{
    Vector2 pos;
    Texture2D *texture;
    double velocity;
    Rectangle rec;
} Obstacle;

typedef enum ScreenStage
{
    MAINSCREEN,
    INGAMESCREEN,
    CLOADING,
    SLOADING,
    LOADING,
    CHOOSE,
} ScreenStage;

typedef struct Game
{
    bool multiplay;
    ScreenStage stage;
    char targetIp[16];
    int cursor;
    bool connected;
    bool isServer;
} Game;

Player *NewPlayer(Texture2D *texture);
void UpdatePlayer(Player *player);
Obstacle *NewObstacle(Texture2D *texture);
void UpdateObstacles(Obstacle **obs, int size, PlayerState state);
````

전체 코드가 400줄에 달하는 관계로 모두 설명하기엔 너무 귀찮으니 메인 함수 선언 이전의 코드만 가져왔다.
`PlayerState` enum은 말 그대로 현재 플레이어의 동작을 나타낸다. IDLE은 아무 동작도 하지 않는 상태, LEFT, RIGHT는 뛰는 방향, DEAD는 장애물에 맞았을 때의 동작이다.
`Player` 구조체는 플레이어의 context, 또는 상태라고 생각하면 된다. 이 플레이어 구조체에는 현재 좌표값과 크기, 텍스쳐, 속도, 크기 등 필요한 요소가 전부 들어가있다.
`Obstacle`은 각 장애물의 상태이며, Player 구조체와 비슷한 기능을 한다.
`ScreenStage`는 화면 상태를 나타내는데, 저렇게 뭐가 많은 이유는 멀티플레이가 가능하게 만드려는 흔적이다. 시간 관계상 결국 멀티플레이 기능은 구현하지 못해 눈물을 머금고 싱글플레이만 할 수 있게 구현했다.
`Game` 구조체는 전체 게임의 상태가 저장되는 구조체이다. 여기서도 실패한 멀티플레이의 흔적을 볼 수 있다.

이후 함수들은 이름 그대로의 기능을 수행한다. Update~로 시작하는 함수들은 1프레임마다 호출된다.

C언어 초보자라서 이렇게 코드를 짜도 되나 하는 생각이 들었지만, 빌드와 실행은 잘 되니까 괜찮은 것 아닌가?!

# 결과

![](https://i.imgur.com/cmpOMxc.png)
![](https://i.imgur.com/4Htm5Z0.png)
![](https://i.imgur.com/xdSM0fJ.png)

# 마치며

처음에는 C언어로 게임을 만든다는 것에 대해 상당히 부정적이었지만, raylib이라는 엄청난 라이브러리를 사용하고 난 후 생각이 바뀌었다.
C언어로도 충분히 게임을 만들 수 있으며, 어렵지 않다.
다만 C#, Python 등 현대적인 언어에 비해 C는 저수준 언어이기 때문에 그에 따른 단점도 있는 것 같다. (전역 변수 선언 충돌, 동적 할당 등)

그러나 C언어로 게임을 만든다고 할 때, 이런 간단한 2D게임은 만들 수 있겠지만 로직이 좀 더 복잡해지거나, 만들어야 하는 게임이 3D라면 유니티, 고도, 언리얼 등의 게임 엔진을 쓰자. 아니면 적어도 객체지향 언어로 게임을 개발하는 게 C로 짜는 것보다 낫다고 생각한다.
