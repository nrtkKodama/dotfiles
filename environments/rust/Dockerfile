# 公式のRustイメージを使用
FROM rust:latest

# 開発に便利なコンポーネントを追加（整形ツールとLinter）
RUN rustup component add rustfmt clippy

# 作業ディレクトリの設定
WORKDIR /app

# コンテナを起動し続けるためのコマンド
CMD ["sleep", "infinity"]
