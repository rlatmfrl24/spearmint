---
title: Toy Project에 대하여
date: '2019-08-29 11:05:11'
draft: false
category: 'Doodle'
---

나는 개발 1년차 중간에 업무가 붕 떠버려서 작업도 없고 목표도 방황만 하면서 2달을 보낸 시기가 있었다. 그래서 놀면 뭐하나싶어서 개발이나 아무거나 만들어보자 싶었던게 Hitomi Downloader(-\_-;;)였다. 사실 GitHub에 누군가 만들어놓은 우수한 기능의 [Hitomi Downloader](https://github.com/KurtBestor/Hitomi-Downloader-issues)가 있었지만, 난 좀더 개인적인 기능이 필요했다.(하지만 저 프로그램은 너무 우월해서 결국 같이 쓰게 됐다.)

Selenium과 WindowBuilder를 활용한 나의 첫 프로젝트는 무사히 완성되어 스스로 만족스럽게 사용했지만, 지금 생각해보면 진짜 무식한 구조였다. DB없이 데이터는 로컬파일에 저장했고, 다운로드 요청은 관리없이 일괄적으로 요청해서 블락당하기 일쑤였다.

이후에 새로 도전했던 것이 파일 관리 시스템이었다. 사실 말이 좋아 파일 관리 시스템이지 이전 프로젝트에 다운로드받았던 만화(?)들을 효율적으로 관리해보고 싶었던 것뿐이었다.

매번 순서대로 감상(?)하는 것도 지겨우니 랜덤하게 추천해주는 모듈도 만들었고, 파일명에 따라 자동으로 폴더 분류를 해주는 모듈도 만들었다. 이 기능들은 당연히 나중에 이전 프로젝트와 합쳐졌다.

이렇게 남부끄러운(?) 프로젝트를 하다보니 양지에서 당당히 개발하고 싶은 욕심이 들었다. 그러다보니 문득 들었던 생각이 커뮤니티 게시글 수집기였다.

나는 인터넷 밈을 굉장히 좋아하고, 밈을 이해하고 수집하는데는 커뮤니티가 필수적이다. 요즘은 커뮤니티별로 성향과 위험도가 천차만별이기때문에 매우 신중해야하고, 위험도가 낮은 커뮤니티에서도 분쟁의 여지가 있는 게시물들이 꽤나 자주 보이는 편이다.

내가 즐겨하는 커뮤니티에서 이런 글들을 제거하고 내가 보고싶은 밈들만 보여주는 기능이 절실했다. 게다가 내가 이미 한번 보거나 내용이 겹치는 게시물도 보고싶지 않았다.

따라서 커뮤니티 게시물 링크를 크롤링한 후, 일반적인 리스트로 나열해주는 프로그램을 만들었다. 이때부터 엉성하긴하지만 어느정도 체계가 잡혀가기 시작했다. DB는 Firebase,클라우드는 AWS 아닌 새로운 플랫폼 써보겠다고 GCP에 올렸고, UI도 PyQt로 좀더 깔끔하게 바꿨다.

직장에서의 크롤러 개발 경험도 많은 도움이 되었다.

그러다보니 후배의 조언을 계기로 안드로이드 프로젝트까지 확장시켜보기로했다. 프로젝트 설계 단계에서 한참 나아가다보니 어느새 Flutter로 개발을 시작하게 되었다. 지금은 Flutter가 좀더 깔끔하고 참여하는 사람도 많아졌지만, 초창기 Flutter는 상태 관리가 진짜 헬이었다.

망가 다운로더, 커뮤니티 게시글 수집기, Flutter 어플리케이션까지 개발하고보니 나의 그동안의 작업물이 얼마나 엉성한지 깨닫게 되었다. 그래서 프로젝트 처음부터 다시 설계해서 3가지 프로그램 다 처음부터 새로 만들었다.

이제 망가 다운로더는 더이상 개발하지않게 되었고(정확히는 더이상 망가를 안보게 됐다), 게시글 수집기는 Node.js와 React JS로 좀더 사용성을 올렸다. 다시금 만든 프로젝트들은 처음보다는 많이 나아졌지만, '더 잘만들수 있었는데...'라는 아쉬움을 지울 수가 없었다.

언제까지고 같은 컨셉의 프로젝트에 묶여있고 싶지 않아서 새로운 컨셉의 프로젝트에 도전해보고자 했지만, 나는 천성이 이과인 관계라서 딱히 맘에 드는 아이디어가 떠오르지 않아서 교착상태에 빠져있다.

여기까지 주저리주저리 나의 Toy Project에 대한 히스토리를 얘기해보았다. 아마 평균 이상되는 개발자분들이 본다면 한숨쉬시며 꿀밤이라도 쥐어박고 싶은 한심한 개발스토리지만, 개인적으로 매우 즐거운 과정이었다.

이 포스트를 계기로 앞서 언급한 게시글 수집기를 좀더 발전시켜 보고자한다. 이제 Concept부터 기획, 설계, UI/UX 개발까지 벌써 3번째 초기화된 개발이다. 심지어 이 컨셉으로 만들어진 [사이트](https://issuelink.co.kr)도 이미 존재한다. 하지만, 아마 Concept 연구 단계에서 좀 변형될거고 좀더 재미있는 프로젝트 컨셉이 나올거라고 생각한다.
