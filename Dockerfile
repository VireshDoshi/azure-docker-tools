FROM centos:7.6.1810
ENV TERRAFORM_VERSION=0.14.2
ENV PACKER_VERSION=1.6.5

RUN yum install -y epel-release
RUN yum update -y
RUN yum install -y wget curl unzip vim jq python3-pip
RUN pip3 install --upgrade pip

RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN rm  terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN install terraform /usr/local/bin/

RUN wget https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl -O /bin/kubectl
RUN chmod +x /bin/kubectl

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN echo -e '[azure-cli] \n\
name=Azure CLI \n\
baseurl=https://packages.microsoft.com/yumrepos/azure-cli \n\
enabled=1 \n\
gpgcheck=1 \n\
gpgkey=https://packages.microsoft.com/keys/microsoft.asc' > /etc/yum.repos.d/azure-cli.repo

RUN yum -y install azure-cli
RUN yum -y install git

RUN yum install ansible -y

RUN curl -Lo /tmp/packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip
RUN unzip /tmp/packer.zip -d /usr/local/bin
RUN rm /tmp/packer.zip 
RUN ln -s /usr/local/bin/packer /usr/local/bin/packer.io

RUN curl https://omnitruck.chef.io/install.sh | bash -s -- -P inspec

RUN yum -y update openssl libcurl
ADD VERSION .

CMD ["/bin/bash"]
