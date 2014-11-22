## Dmhy Filter ##
Dmhy Filter為特別為動漫花園設計的RSS過濾器，設定每筆項目的關鍵字後，配合crontab設定，可自製個人的RSS供各Bittorrent程式或服務訂閱，達到自動下載的目的。

## How to ##

### Filter ###
於目錄下建立filter，如`filter.txt`，每行代表一個目標，以空白作為萬用字元

```
【極影字幕社】★10月新番 SHIROBAKO / 白箱 第7話 BIG5 720P MP4
```

可以用下面的方式來表示
```
極影 SHIROBAKO BIG5 720P
```

### Config ###
config檔以YAML格式描述，放置於目錄下的`config.yml`，代表意義如下描述
```yaml
---
source: Dmhy的RSS網址
filter: filter檔位置
output: 自訂RSS輸出位置
expired_day: 從RSS中刪除N天前的項目
last_updated: 最後更新時間
```

預設的config檔可透過第一次執行程式自動產生，`last_updated`不須自行設定，此紀錄為程式為了加快執行效率，判斷上次讀取項目位置所需。

### Cron Job ###
為了24H不間斷的更新最新訊息，要把Dmhy Filter註冊在crontab中，建議5~10分鐘更新一次
```
*/5 * * * * ruby /path/to/dmhy-filter/dmhy_filter.rb
```

## License ##
The MIT License (MIT)
```
Copyright (c) 2014 Mingc

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
