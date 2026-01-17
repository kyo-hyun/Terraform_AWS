# AWS Multi-VPC Architecture with Network Firewall & EKS

이 프로젝트는 **Terraform**을 사용하여 AWS 환경에 보안이 강화된 Hub-and-Spoke 형태의 인프라를 구축합니다. 중앙 집중식 보안을 위한 **AWS Network Firewall(NFW)**과 고가용성 **EKS 클러스터**를 포함하며, 모든 리소스는 모듈화되어 관리됩니다.

---

## 🏗 Architecture Diagram

![Architecture Diagram](./image/architecture.png)

이 아키텍처의 주요 특징은 다음과 같습니다:
* **Centralized Security**: AWS Network Firewall을 통해 인바운드/아웃바운드 트래픽을 전수 검사합니다.
* **Traffic Isolation**: Public 및 Private 서브넷을 엄격히 분리하여 보안성을 높였습니다.
* **Container Orchestration**: 2개의 가용 영역(AZ)에 걸쳐 고가용성 EKS 클러스터를 배치했습니다.
* **Efficient Connectivity**: VPC Endpoint와 ALB를 통해 서비스 간 통신 및 외부 노출을 안전하게 관리합니다.

---

## 📂 Project Structure

본 프로젝트는 서비스별로 독립된 모듈 형식을 채택하여 유지보수성과 재사용성을 극대화했습니다. 각 `.tf` 파일은 해당 리소스의 모듈을 호출하여 실제 인프라를 생성합니다.

.
├── module/               # 재사용 가능한 개별 리소스 모듈 정의
│   ├── EC2/              # Bastion Host 등 인스턴스 구성
│   ├── EKS/              # EKS 클러스터 및 Node Group
│   ├── IAM_Role/         # 서비스별 IAM Role 및 Policy
│   ├── NFW/              # Network Firewall 및 Rule Group
│   ├── VPC/              # VPC, Subnet, Route Table
│   └── ... (기타 모듈)
├── vpc.tf                # VPC 모듈 호출 및 전체 네트워크 구성
├── eks.tf                # EKS 인프라 정의
├── nfw.tf                # 보안 필터링 및 방화벽 규칙 정의
├── lb.tf                 # 로드 밸런서(ALB/NLB) 구성
├── sg.tf                 # 보안 그룹 설정
├── provider.tf           # AWS Provider 및 Terraform 버전 설정
└── variables.tf          # 프로젝트 공통 변수 관리

---

## 🚀 Deployment & Implementation

### 1. Prerequisites
* Terraform v1.0.0+
* AWS CLI 설치 및 `aws configure`를 통한 자격 증명 설정
* kubectl (EKS 클러스터 제어용)

### 2. Step-by-Step Guide

# 1. 리포지토리 클론
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name

# 2. 테라폼 초기화 (모듈 및 프로바이더 로드)
terraform init

# 3. 인프라 변경 사항 및 리소스 생성 계획 확인
terraform plan

# 4. 리소스 배포 (실제 AWS 리소스 생성)
terraform apply -auto-approve

---

## 🛠 Key Components & Technologies

| Component | Description |
| :--- | :--- |
| **AWS NFW** | 침입 방지 시스템(IPS) 및 필터링 규칙을 적용한 네트워크 보안 계층 |
| **Amazon EKS** | 안정적인 컨테이너 애플리케이션 운영을 위한 관리형 Kubernetes 서비스 |
| **ALB** | 애플리케이션 계층(L7)의 트래픽 분산 및 경로 기반 라우팅 |
| **Terraform Modules** | 리소스 간 의존성을 관리하고 재사용 가능한 인프라 코드 구조화 |

---

## 📝 Usage Notes
* **Network Firewall Rules**: 규칙 변경이 필요한 경우 module/NFW의 Rule Group 정의 파일을 수정하세요.
* **EKS Access**: 배포 완료 후 아래 명령어로 kubeconfig를 업데이트하여 클러스터에 접속하세요.
  aws eks update-kubeconfig --region <your-region> --name <cluster-name>
* **Cleanup**: 테스트 후 리소스를 삭제하려면 아래 명령어를 사용하세요.
  terraform destroy -auto-approve