
강의 정리. (출저: 코딩애플 DOCKER)

[이미지와 컨테이너 개념]

이미지 : OS, 실행에 필요한 프로그램, 라이브러리, 소스코드 등이 있다.

도커 사용시
- 내 작업환경이랑 코드를 그대로 이미지로 만든 후
- 이미지를 그 서버 컴퓨터로 옮겨서 실행만 눌러두면 된다.

도커 데스크탑에서 이미지 설치가 가능하지만,

터미널 사용시
- docker pull 이미지이름:태그명

컨테이너 실행 시 데스크탑에서 재생버튼을 누르면 되지만,

터미널 사용시
- docker run 이미지이름:태그명

컨테이너 실행에서서
포트 8080 입력 시, 
내 컴퓨터의 8080포트로 들어가면 해당 컨테이너의 80번 포트로 안내해주세요. 라는 뜻

결론
1. OS, 개발환경, 소스코드 등을 담아서 이미지를 만들 수 있다.
2. 이미지를 실행중인 가상컴퓨터가 컨테이너다.

[서버 만들기]

node express 사용해서 서버하나 열기

DOCKER 를 사용하면 내 환경, 코드를 이미지로 만들 수 있다.

1. 내 환경과 코드를 이미지로 만들기
2. AWS컴퓨터에 그대로 이미지를 옮겨서 실행판 하는게 간단하며 에러도 적다.

Q. 이미지는 어떻게 만드는가?
- Dockerfile 생성
( 
    어떤 OS를 설치해야 하는가
    어떤 프로그램과 라이브러리를 설치해야 하는가
    어떤 터미널 명령어를 실행할것인가
)
- docker build 명령어 사용 다음시간에.

[Dockerfile 명령어 & 이미지 만들기]

이미지 만들고 싶으면
1. 코드짠거 근처에다가 Dockerfile 생성
2. 이미지에 뭘 넣을지 작성
3. 터미널에 docker build 명령어 사용

ex)
- OS하나 설치하고
- nodejs 설치하고
- npm i express 터미널에 입력
- 서버 코드 작성
- node server.js 터미널에 입력

FROM 명령어 <<
어떤 OS환경에서 내 프로그램을 실행할지부터 정해야한다.
FROM 뒤에 어떤 OS를 설치해서 시작할건지 정하면 되는데,
그건 Docker hub 에서 찾아오면 된다.

예를 들어 윈도우 설치하고 싶으면 windows 검색해서 그거 기재,
리눅스 OS를 설치하고 싶으면 (ubuntu, devian, redhat, alpine) 이런거 검색해서 기재

보통은 리눅스가 서버비가 덜 들기 때문에 리눅스를 사용한다.

예시 FROM 사용법)
FROM ubuntu:25.04

이런식으로 Dockerfile에 기입하면 ubuntu 25버전이 설치된 채로 시작가능하다.

아니면 리눅스 + Node.js 함께 설치된걸 이미 만들어준 사람들것을 사용한다.
node 를 검색/선택하여 나온 버전들 중에

FROM node:22-alpine 이런걸 기재하면

Node.js 22버전과 alpine 리눅스 OS가 설치된 채로 시작할 수 있다.
참고로 slim은 devian 리눅스에서 필요없는거 지운거고 alpine은 용량이 가장 작은 리눅스라서 가장 선호한다.

FROM node:20-slim
내가 쓰는 Node.js 버전 쓰는게 좋다.

FROM scratch
참고로 바이너리로 컴파일한 파일만 돌리면 되는 경우엔
OS 설치가 딱히 필요없을 수 있는데 그럴 땐 빈 도화지에서 시작하라고 이걸 쓴다.

RUN 명령어 <<

실행 할 스크립트 명령어들

RUN npm install express

터미널 명령어처럼 실행해줍니다.
RUN은 여러번 써도 된다.

하지만 이러면 설치할 라이브러리가 많을때마다 그 숫자만큼 써야하고,
최신버전 express 라이브러리를 설치해주기 때문에 귀찮아질 수 있다.

좋은 방법은
내가 쓰던 package.json 파일을 먼저 똑같이 복사해오고,
그 다음에 npm i만 입력하면, 그 package.json에 기록되어 있던
라이브러리들 그대로 설치해주는 기능이 있기 때문에, 그걸 사용해본다.

COPY 명령어 <<
내 컴퓨터에 있던 파일을 이미지로 복사하려면 COPY 명령어를 쓰면 된다.
아무거나 복사 가능.

COPY 내컴퓨터파일경로 이미지내부파일경로

(Dockerfile)

FROM node:20-slim
COPY . .

* Dockerfile 현재경로 옆에 있던 모든 파일과 폴더들을 가상컴퓨터 현재경로로 복사해달라는 뜻
그러면 소스코드도 전부 복사되어서 편하다.

하지만 해당 경로의 모든 소스코드를 복사하므로,
.dockerignore 파일을 만들어서 제외할 경로나 파일을 기재해둔다.

WORKDIR 명령어 <<

이미지 기본 경로에 옮기면 파일이 많아서 더러울 수 있으니까
/app 같은 폴더 하나 만들어서 거기로 이동하게 한다.

(Dockerfile)

FROM node:20-slim
WORKDIR /app
COPY . .

* 현재 작업경로를 /app 폴더로 바꿔주고 /app 폴더가 없으면 하나 만들어줍니다.
터미널 명령어중에 cd와 비슷한 역할을 한다.

다시 RUN 명령어

그 다음에 npm i을 터미널에 입력하면 package.json에 기재된 라이브러리가 설치되게

RUN ["npm", "install"]

RUN npm install 이렇게 써도 되는데 대괄호치는게 더 안정적인 방식이다.
괄호 안치면 /bin/sh -c npm install 명령어가 실행이 되는데,
내 OS에 기본적으로 설치된 shell을 이용해서 실행하라는 말이다.

그래서 shell이라는 프로그램과 거기서 제공하는 && || 이런 명령어가 필요하면
괄호없이 쓰면 되지만, shell 기능이 필요없거나 OS마다 shell이 서로 다를 수 있기 때문에
불안하면 대괄호를 쓴다. 

CMD 명령어 <<

이제 node server.js 입력하면 파일이 실행되고 그러면 웹서버가 실행되는데,

Dockerfile에 작성해주면 된다.
RUN node server.js 하면 될거 같지만,

보통 마지막 명령어는 RUN 말고 CMD 뒤에 적는다.
CMD 대신에 ENTRYPOINT 라고 적을 수도 있다.

=> 내 이미지를 실행할 때 터미널에서 실행하고 싶으면
docker run 이미지명 하면되지만,
docker run 이미지명 node server1.js 이렇게 작성해주면,
Dockerfile 내의 CMD 부분이 node server1.js로 덮어쓰기가 되어서 실행된다.
그래서 매번 다른 명령어로 실행하고 싶으면 CMD 사용하면 덮어쓰기가 편해진다.

- 변경을 원하지 않는 부분은 ENTRYPOINT 에 넣고,
- 변경을 원하는 부분은 CMD 에 넣는다.

ex.)
(Dockerfile)
(...생략)
ENTRYPOINT ["node"]
CMD ["server.js"]

이런식으로 적어두면,
이미지를 실행할때 docker run 이미지명 server1.js 이렇게 실행하면
node server1.js 라는 커맨드가 마지막에 실행된다.
그래서 docker run 할 때마다 일부 명령어만 가변적으로 덮어쓰기 하고 싶을때
이런식으로 사용이 가능하다.

EXPOSE 명령어 <<

포트번호 기재하는 명령어


이미지를 만들려면 docker build

docker build -t 이미지이름:태그 .

Dockerfile 작성했으면 이걸 바탕으로 이미지를 하나 만들 수 있다.

터미널을 열고
- 이미지 이름은 맘대로 작명
- 태그도 맘대로 작명. 태그는 버전이랑 비슷하게 취급
- 마침표자리에는 Dockerfile 경로 입력하면 된다
- docker desktop 또는 docker engine 이 실행되고 있어야 명령어 사용가능.

이미지 실행하기

재생버튼을 눌러서 포트번호를 입력해서 동작하게 하든가, docker run 명령어 사용

터미널 사용시
docker run -p 8080:8080 이미지명:태그명
=> 누가 내 컴퓨터 포트 8080으로 들어오면 가상 컴퓨터의 8080으로 연결하라

그 뒤에 브라우저에서 localhost:8080 입력하면 웹서버를 볼 수 있다.

docker init 명령어를 사용하면 Dockerfile을 자동완성 해주는데 거기서 수정하는게 편하다.

[컨테이너 다루기]

docker desktop이 안에서 docker의 모든 기능을 쓸수 있는건 아니다.
터미널 명령어 실행해서 쓰는 일이 많다.

이미지 실행 터미널에서 하려면.
docker run -d 이미지명:태그명

-d(detatched의 약자) 옵션을 넣으면 백그라운드에서 실행가능하다.

이미지 실행시 포트 설정
docker run -p 8081:8080 -d 이미지명:태그명
=> 내컴퓨터 8081 로 접속하면 8080 컨테이너로 안내
* 포트 설정 없이 띄우면 브라우저 접속했을 때 아무것도 렌더링 안됨

이미지를 실행할 때 포트를 설정해주고 싶으면 -p 넣고 내컴퓨터포트:컨테이너포트 

컨테이너 관련한 명령어들.

docker ps
=> 현재 실행중인 컨테이너들을 살펴볼 수 있다.

docker logs
=> 컨테이너 컴퓨터 터미널의 로그 출력이 가능하다.

docker exec -it 컨테이너이름 sh
=> 특정 컨테이너 터미널로 접속이 가능하다.

ctrl + p 이후 ctrl + q
=> 컨테이너 탈출

docker stop 컨테이너이름 또는 컨테이너 아이디
=> 실행중인 컨테이너 정지

docker rm 컨테이너이름
=> 정지된 컨테이너를 삭제해준다. 정지 안된 컨테이너를 삭제하려면 -f 옵션 붙이기

컨테이너 구조.

리눅스 OS가 제공하는 기능을 섞은것

리눅스의 namespace 기능을 사용하면
프로그램마다 서로 영향을 끼치지 않게 독립적으로 프로세스와 파일구조 같은걸 분리해준다.

리눅스의 cgroup 기능을 사용하면
프로그램마다 CPU나 램을 얼마나 점유할 건지 정해둘 수 있다.

이런걸 사용하면 독립적으로 동작하는 가상 컴퓨터를 만들 수 있는데,
그걸 "컨테이너"라고 부르는 것이다.

컨테이너는 여러개를 띄울 수 있어서 컴퓨터 한대에서 여러 컴퓨터를 운영하는것 처럼 느낄 수 있다.
컨테이너에서 문제가 생겨도 내 컴퓨터로 전염되는 일이 거의없는 장점

원래 runc같은 프로그램을 쓰면 컨테이너를 띄울 수 있고
containerd 라는 프로그램으로 runc를 조작하면 편리하다.
이런것들을 쉽게 사용할 수 있게 만든 프로그램이 Docker.
거기에 이미지 빌드기능, pull기능, 관리기능을 추가하면서 개발자들을 편하게 해준다.

[성능을 위한 Dockerfile 작성법]

docker build 시간 단축, 용량 절약, 보안 향상을 위한 방법이 있다.

1. 캐싱

프로젝트가 커지면 dockerbuild 기다리는 시간이 길어진다.
배포할 떄마다 기다리면 많은 시간을 소비할 수 있다.

Dockerfile 작성 시 "빌드할 때마다 변동사항이 많이 생기는 부분들을 최대한 아래 쪽에 적어둔다"
=> 빌드 작업할때 COPY, RUN 명령을 실행할 때 마다 도커가 캐싱을 한다.
- 캐시된 명령어들은 매우 빠르게 처리
- 변동사항이 생긴 명령어부터는 캐싱된걸 사용X
- 변동사항이 많은건 좀 아래쪽으로 내린다.

ex.)
Node.js로 웹서버 개발하는 경우는
package.json 내용이나 npm i 라이브러리 설치하는건 날마다 변동사항이 거의 없다.

그래서
1. OS와 Node.js 설치
2. package.json 먼저 옮겨서 라이브러리 설치
3. 그 다음에 자주 변경되는 소스코드를 옮긴다

위처럼 작성하면 docker build 할 때 약간이라도 더 빨라질 수 있다.

(Dockerfile) *반영된 수정 Dockerfile

FROM node:20-slim
WORKDIR /app
COPY package*.json .
RUN ["npm", "install"]

COPY . .
EXPOSE 8080
CMD ["node", "server.js"]

2. npm ci

npm i => ^ 달아놓은건 다 최신버전으로 설치
npm ci => package-lock.json 을 참고하여 현재 버전을 설치

3. ENV

(Dockerfile)

ENV NODE_ENV=production
CMD 어쩌구~

ENV 라는 명령어를 쓰면 환경변수를 집어 넣어서 이미지를 빌드할 수 있다.
ENV 환경변수이름=값을 사용

옛날부터 존재하던 express 같은 라이브러리들은
NODE_ENV=production 을 집어넣어놔야 로그 출력량을 줄이고, 성능이 향상
그래서 Node.js 개발 시 설정해두면 좋다.

참고로 docker run 할 때도 -e 옵션으로 환경변수를 넣어서 이미지 실행 가능.

4. 권한 낮추기

기존 Dockerfile에 적은 명령어들은 전부 root 권한으로 실행된다.
마지막에 서버 띄우는 명령어는 root 말고 권한을 좀 낮춰서 실행하는게 안전

유저를 하나 생성하고 해당 유저로 바꿔서 실행하라고 하면되는데,
node 공식 이미지의 경우엔 node라는 이름의 유저가 이미 만들어져있다.

(Dockerfile)

USER node
CMD 어쩌구~

USER 유저이름 적으면 해당 유저로 변경된다.


multi-stage build

FROM amazoncorretto:21.0.4 AS build
WORKDIR /app
COPY . .
RUN  ./gradlew build

# Runtime stage
FROM amazoncorretto:21.0.4 AS runtime
WORKDIR /app
COPY --from=build /app/build/libs/*.jar /app/server.jar
CMD ["java", "-jar", "/app/server.jar"]

Dockerfile에 FROM을 2번 이상 작성할 수 있다.
FROM을 만달 때 마다 위에 작업내역들이 삭제되고 새롭게 시작 가능
새롭게 시작할때 위의 작업내역에서 만든 파일들을 가져올 수 있다.

1. 첫째 FROM에선 /app 폴더에서 .jar파일만 만든다.
2. 두번째 FROM에선 이전 FROM에서 나온 .jar 파일을 /app/server.js 경로로 가져오라
--from=build 가 build라고 이름 지은 곳에 잇던 파일을 카피하라는 뜻.
(AS 명령어 사용하면 FROM마다 이름을 마음대로 붙일 수 있다.)
마지막에는 .jar 파일을 실행하는 것

그럼 최종 이미지에는 .jar파일 , 리눅스OS, 자바21 JDK 이 정도만 들어있어서 가벼워진다.
FROM 여러번 쓰는 것을 multi-stage build 라고 한다.

빌드과정이 필요한 프로젝트들은 이런 식으로 작성해서 용량을 주링고 보안도 조금 올릴 수 있다.


Next.js 프로젝트는

npm run build 명령어를 입력하고 npm start 로 코드 실행
빌드 과정이 필요하기 때문에, Dockerfile 작성핼 때 multi-stage build를 이용해서 용량 절감
그보다 간편한건 nextjs output standalone을 알아보기

[Docker hub, push, pull]
