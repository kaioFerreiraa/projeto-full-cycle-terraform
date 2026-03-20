locals {
  kubeconfig = <<KUBECONFIG
    apiVersion: v1
    clusters:
    - cluster:
        certificate-authority-data: ${aws_eks_cluster.new-cluster.certificate_authority[0].data}
        server: ${aws_eks_cluster.new-cluster.endpoint}
      name: kubernetes
    contexts:
    - context:
        cluster: ${aws_eks_cluster.new-cluster.name}
        user: ${aws_eks_cluster.new-cluster.name}
      name: ${aws_eks_cluster.new-cluster.name}
    current-context: ${aws_eks_cluster.new-cluster.name}
    kind: Config
    preferences: {}
    users:
    - name: ${aws_eks_cluster.new-cluster.name}
      user:
        exec:
          apiVersion: client.authentication.k8s.io/v1beta1
          command: aws-iam-authenticator
          args:
            - "token"
            - "-i"
            - ${aws_eks_cluster.new-cluster.name}
    KUBECONFIG
}

resource "local_file" "kubeconfig" {
  filename = "kubeconfig"
  content  = local.kubeconfig
}
