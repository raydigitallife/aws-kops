# 使用 KOPS 在 AWS 建立 Kubernetes 叢集

## 預先準備

- 為了測試方便，IAM 使用 `admin` 的金鑰, 用完記得刪除
- cloud9 執行環境  
    - c9-lab-ide-build.sh 可以增加自己的參數
    - 取消 c9 介面內的 temp credentials
    - 先取得 S3 儲存 state 的路徑, 這是 `kops`必要的設定
    - c9-lab-ide-build.sh 執行完後, 需在 ~/.kube 將空白的設定檔刪除掉
        -  會有空白設定檔是因為 EKS 測試所需

## 自動 KOPS
    - 執行 `kops-cluster.sh` 直接給與 `create` 或 `delete` 變數
    - kops-cluster.sh 內的參數應適當調整

## 手動 KOPS
- 預設會啟動 1 Master, 3 Nodes, t2.medium 的 spot EC2 做為測試環境
- 建立叢集:
    1. `kops create -f kops-cluster-m1-n3.yaml  `
    2. `kops create secret --name c9.k8s.local sshpublickey admin -i ~/.ssh/id_rsa.pub  `
    3. `kops update cluster c9.k8s.local --yes  `
    4. 等一下如果沒有問題就會建立好叢集，接著就可以在 c9 內用 kubectl 操作  

- 刪除叢集  
    1. 執行`kops delete -f kops-cluster-m1-n3.yaml`即可，如果最後不加上 `--yes`  
    會先列出即將刪除的資源清單確認  
    2. 刪除一樣等他跑完就刪除了, 沒什麼難度  

## kubectl
- KOPS 會自動將設定檔帶到執行環境, 一般來說不用特別設定等 KOPS 正常跑完即可  
- `kubectl get nodes` 如果都有取得資訊就沒問題了

## 部署metrics-server
-   這可以取得Nodes本身的CPU與RAM  
-   `kubectl apply -f metrics-server/deploy/1.8+/`
-   同樣的方式部署在EKS叢集就會有錯，但KOPS自建的叢集卻沒有問題??  
-   可能跟EKS master 有限制部份功能的關係??
-   確認是AWS的EKS issue，要一段時間後才會修復  

## kops update cluster version
-   預設kops產生的 cluster 為V1.9.6版的，可到  
    `https://github.com/kubernetes/kubernetes/releases`  
    取得最新版本  
-   部署後升級cluster版本  
    `kops replace -f 新版的部署文件`  
    `kops update cluster --yes`  
    `kops rolling-update cluster --yes`  
    如果沒有加 `--yes` 會再提示，並有動作清單參考  
-   更新過程可能會很久，不需要特別測試反正等他跑完就換成新版本了
-   結果 1M 3N 的規模跑完大概是半個多小時
-   開始建叢集時指定好新版本即可

## 壓力測試 (未完成)
-   前提是metrics-server能正確的取得cpu度量，否則autoscale不會有動作
-   kubect scale deploy 目標 --re


