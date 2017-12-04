
# データを保存するディレクトリ。public_htmlの外にすること。
PRIVATE_DIR = "/home/hori/wwwdata/book"

# 1画面に何メッセージ表示するか
PAGE_SIZE = 15

# セッション維持時間（秒単位）
HOLD_TIME = 10 * 60

# セッション情報を保存するディレクトリ
SESSION_DIR = PRIVATE_DIR + "/session"

# ユーザーID、パスワード、ユーザー名を記録するファイル
PWD_FILE = PRIVATE_DIR + "/pwdfile"

# 投稿データを保存するディレクトリ
DATA_DIR = PRIVATE_DIR + "/data"

# 削除された投稿データを保存するディレクトリ
DELETED_DIR = PRIVATE_DIR + "/deleted"

# セッション越えのユーザー情報を保存するディレクトリ
PROFILE_DIR = PRIVATE_DIR + "/profile"
PROFILE_FILE = PRIVATE_DIR + "/profile/profile.db"
