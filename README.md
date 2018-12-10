# WedAT

結婚式のために用意した招待状アプリケーションのデモ版です。
ローカルに構築する場合でも Cognito などのサービスへの接続が必要なので、先にプロビジョニングをしないと動きません。

## Setup

```console
$ cp src/configuration.js{.sample,}
$ yarn install
$ yarn start
```

## Provisioning

```console
$ cd terraform
$ terraform apply
```

## Deploy

```console
$ bin/deploy <profile> <bucket>
```
