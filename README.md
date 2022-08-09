# The-Composable-Architecture
iOS Application Created By The Composable Architecture

# 目的
- 現在運用しているiOSアプリのリファクタリング
- The Composable Architectureの理解

# ディレクトリ構造
── **View**<br/>
<span style="margin-left:2em">├── **LaunchScreen**<br>
<span style="margin-left:4em">├── LaunchScreenView.swift<br/>
<span style="margin-left:4em">└── LaunchDesignView.swift<br/>
<span style="margin-left:2em">├── **Home**<br>
<span style="margin-left:4em">├── HomeView.swift<br/>
<span style="margin-left:4em">├── HomeHeaderView.swift<br/>
<span style="margin-left:4em">├── HomeMenuView.swift<br/>
<span style="margin-left:4em">├── MenuView.swift<br/>
<span style="margin-left:4em">├── **Reservation**<br/>
<span style="margin-left:6em">├── ReservationView.swift<br/>
<span style="margin-left:6em">├── ReservationListView.swift<br/>
<span style="margin-left:6em">├── ReservationRowView.swift<br/>
<span style="margin-left:6em">└── CancelButtonView.swift<br/>
<span style="margin-left:4em">└── TicketView.swift<br/>
<span style="margin-left:2em">├── **MakeReservation**<br>
<span style="margin-left:4em">└── MakeReservationView.swift<br/>
<span style="margin-left:2em">├── ActivityIndicator.swift<br>
<span style="margin-left:2em">└── AppHeaderView.swift<br>
── **Store**<br/>
<span style="margin-left:2em">├── LaunchStore.swift<br>
<span style="margin-left:2em">├── HomeStore.swift<br>
<span style="margin-left:2em">├── MakeReservationStore.swift<br>
<span style="margin-left:2em">├── ReservationStore.swift<br>
<span style="margin-left:2em">├── RootStore.swift<br>
<span style="margin-left:2em">└── TicketStore.swift<br>
── **Client**<br/>
<span style="margin-left:2em">├── ReservationClient.swift<br>
<span style="margin-left:2em">└── TicketClient.swift<br>

# 役割
|ファイル名|役割|
|:--|:--|
|LaunchScreenView|起動後最初に表示するView|
|LaunchDesignView|LaunchScreenViewのデザインView|
|HomeView|予約情報とチケット情報、メニューを表示するView|
|HomeHeaderView|HomeViewのヘッダーView|
|HomeMenuView|HomeViewのメニューView|
|MenuView|HomeMenuViewのメニューのデザインView|
|ReservationView|予約情報を表示するView|
|ReservationListView|予約情報の一覧を表示するView|
|ReservationRowView|予約情報を表示する1つの行のデザインView|
|CancelButtonView|予約キャンセル時に使用するButtonView|
|TicketView|チケット情報を表示するView|
|MakeReservation|予約を行うView|
|ActivityIndicator|通信中に表示するインジケーターView|
|AppHeaderView|HomeView以外で使用するヘッダーView|
|LaunchStore|起動時のアニメーション制御するStore|
|HomeStore|ReservationStoreとTicketStoreをとりまとめたStore|
|MakeReservationStore|予約を行うときに使用するStore|
|ReservationStore|予約情報の取得、キャンセル等を制御するStore|
|RootStore|未使用(テストで作成)|
|TicketStore|チケット情報を取得するStore|
|ReservationClient|Cloud Functionから予約情報を取得する用のClient|
|TicketClient|Cloud Functionからチケット情報を取得する用のClient|



