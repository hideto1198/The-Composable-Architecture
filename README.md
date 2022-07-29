# The-Composable-Architecture
iOS Application Created By The Composable Architecture

# 目的
- 現在運用しているiOSアプリのリファクタリング
- The Composable Architectureの理解

# View
- HomeView
> ReservationView、TicketViewを取りまとめたView
- HomeMenuView
> メニューを表示するView
- HomeHeaderView
> HomeView専用のHeaderView
> アプリ起動時最初に表示されるView
- ReservationView
> ReservationViewとReservationRowViewを取りまとめたView
- ReservationListView
> ユーザの予約情報を全て表示するView
- ReservationRowView
> 予約情報表示のデザインView
- TicketView
> ユーザの所持しているチケットを表示するView

# Clinet
- ReservationClient
> Google Cloud Platformと通信を行って結果を処理する
- TicketClient
> Google Cloud Platformと通信を行って結果を処理する

# Store
- ActionStore
> TicketStoreとReservationStoreの橋渡しで使用する
> ReservationViewで予約をキャンセルした後にTicketStateを変更する用
- TicketStore
> TicketView用、ユーザーが所持しているチケットの情報を所持する
- ReservationStore
> ユーザーの予約情報を取得し、保持する。



