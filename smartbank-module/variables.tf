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
}

