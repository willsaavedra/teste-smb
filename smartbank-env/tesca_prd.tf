module "tesca_prd" {
  source = "../cloud4erp-default/"
  name = "smartbank"
  class_instance = "t2.micro"
  size_volume = "200"
}