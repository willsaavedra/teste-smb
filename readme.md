# Preparando ambiente

**Para rodar o ambiente é necessario alguns pré-requisitos:**

* Git
  * https://git-scm.com/
* Terraform
  * https://www.terraform.io/downloads.html

* O Terraform contido no repositorio contempla os recursos abaixo:
    ● VPC
    ● IGW
    ● Subnet Pública
    ● Subent Privada
    ● EC2
    ● RDS ( postgresql )

# Instalando API 

**Clonando repositorio**

https://github.com/willsaavedra/teste-smb.git

```bash
git clone https://github.com/willsaavedra/teste-smb.git
```

**Executando o codigo**

```bash
# Entre no diretorio smartbank-env
cd ./smartbank-env

# Terraform Init
terraform init

# Gerando o plano de execução
terraform plan
```

# Variaveis a serem preenchidas

############# Chave AWS #############

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS_ACCESS_KEY_ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS_SECRET_ACCESS_KEY"
}

variable "AWS_REGION" {
  description = "AWS_REGION"
}

############# Variaveis do deploy #############

# # # # # # # Nome Ambiente # # # # # # #

variable "name" {
  description = "The name for the resource"
  default = "example"
}

# # # # # # # Classe da intancia # # # # # # #

variable "class_instance" {
  description = "Tipo de Servidor AWS"
}

# # # # # # # Tamanho do disco a ser criado # # # # # # #

variable "size_volume" {
  description = "Tamanho do disco"
  default = "50"