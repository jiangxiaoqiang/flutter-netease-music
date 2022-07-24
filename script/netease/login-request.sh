#!/usr/bin/env bash

set -u
set -e
set -x

ck="NMTID: '00ONBk-l7B_pqDlK0h6mJLiP5d7ynQAAAGB9ptfew',
        Expires: 'Sat, 10 Jul 2032 08:09:46 GMT',
        'Max-Age': '315360000',
        Domain: 'music.163.com',
        Path: '/',
        os: 'pc',
        __remember_me: 'true',
        MUSIC_U: 'a491172e0afcb60f61012e1a4e061a8720ed0d8d990cd393713421d9c463ef6a519e07624a9f00533502cf0495a044fbb40d28e24665d9c5d0d6e24518f0df6fa46fc8dc5844c667a89fe7c55eac81f3',
        __csrf: 'ebd59ab567d1b440f8258a46b538a149',
        appver: '2.9.7'"

curl -L -X POST --cookie "NMTID:00ONBk-l7B_pqDlK0h6mJLiP5d7ynQAAAGB9ptfew" https://music.163.com/api/login/cellphone \
-H "Content-Type: application/json" \
--data '{"phone":"15683761627","countrycode":"86","password":"","rememberLogin":"true","csrf_token":"fdca38402d0c204ff0d32c48615407b8","crypto":"weapi","ua":"pc","cookie":{"NMTID":"00ONBk-l7B_pqDlK0h6mJLiP5d7ynQAAAGB9ptfew","Expires":"Sat, 10 Jul 2032 08:09:46 GMT","Max-Age":"315360000","Domain":"music.163.com","Path":"/","os":"pc","__remember_me":"true","MUSIC_U":"a491172e0afcb60f61012e1a4e061a8720ed0d8d990cd39396a7a6004d758bc7519e07624a9f0053a9c0a684937f2cf659b8a18592fe5945d0d6e24518f0df6fa46fc8dc5844c667a89fe7c55eac81f3","__csrf":"fdca38402d0c204ff0d32c48615407b8","appver":"2.9.7"}}'


