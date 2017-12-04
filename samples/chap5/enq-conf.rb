
# データを保存するディレクトリ。public_htmlの外にすること
PRIVATE_DIR = "/home/hori/wwwdata/book"

# 質問ファイルを置くディレクトリ。
# 質問ファイルのファイル名は質問番号
QUESTION_DIR = PRIVATE_DIR + "/q"

# 結果ファイルを置くディレクトリ。
# CGIスクリプトがファイルを生成できること
RESULT_DIR = PRIVATE_DIR + "/a"

# 多重投票チェックファイル
CHECK_FILE = PRIVATE_DIR + "/check"

# 連続投票のチェック時間。秒単位
CHECK_TIME = 10

# グラフの最大幅。ピクセル単位
WIDTH_MAX = 400
