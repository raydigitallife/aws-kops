# aws-kops 測試

### C9預先條件

- 為了測試方便，請用IAM取得`admin`的key，用完記得刪除  
- 設定`aws configure`  
- 設定完aws cli後測試一下看能不能用 `aws s3 ls`  

- cloud9先建立一個編輯與執行環境  
    - 取消c9介面內的暫時credentials  
    - 先取得S3儲存state的路徑，這是 `kops`必要的設定  
    - `c9-first-lab-ide-build.sh`進行第一次的c9環境設定  
    - `c9-first-lab-ide-build.sh`可以增加自己的參數  

### kops於AWS建立一個叢集的環境說明
- 預設會啟1 Master , 3 Nodes t2.medium 的spot EC2做為測試環境
- 直接使用kops create -f 檔案名稱部署
- 部屬叢集:  
    1. `kops create -f kops-cluster-m1-n3.yaml  `
    2. `kops create secret --name c9.k8s.local sshpublickey admin -i ~/.ssh/id_rsa.pub  `
    3. `kops update cluster c9.k8s.local --yes  `
    4. 等一下如果沒有問題就會建立好叢集，接著就可以在c9內用kubectl操作  

- 刪除叢集  
    1. 執行`kops delete -f kops-cluster-m1-n3.yaml`即可，如果最後不加上 `--yes`  
    會先列出即將刪除的資源清單給你確認  
    2. 刪除一樣等他跑完就刪除了，沒什麼難度  



### kubectl

- kops會自動將設定檔帶到執行環境，一般來說不用特別設定等kops正常跑完即可  
- `kubectl get nodes` 如果都有取得資訊就沒問題了  

### 部署metrics-server
-   這可以取得Nodes本身的CPU與RAM  
-   `kubectl apply -f metrics-server/deploy/1.8+/`
-   同樣的方式部署在EKS叢集就會有錯，但KOPS自建的叢集卻沒有問題??  
-   可能跟EKS master 有限制部份功能的關係??


### 簡單的壓力測試，前提是metrics-server能正確的取得cpu度量，否則autoscale不會有動作
kubect scale deploy 目標 --re





### 对tomcat service进行压力测试

kubectl run -i --tty load-generator --image=busybox /bin/sh

If you don't see a command prompt, try pressing enter.
/ # while true; do wget -q -O- http://tomcat.default.svc.cluster.local:8080 > /dev/null; done

while true ; do wget -q -O- http://100.67.162.142 > /dev/null ; done

https://blog.frognew.com/2017/01/kubernetes-pod-scale.html