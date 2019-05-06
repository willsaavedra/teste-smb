module "teste-smartbank" {
  source = "../smartbank-module/"
  name = "smartbank"
  class_instance = "t2.micro"
  size_volume = "200"
}