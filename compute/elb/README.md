# Terraform AWS Module : LoadBalancer 

### variable "Network_Load_Balancer" 
|Key        |Type       |Requried   |Remark|
|:---       |:---:      |:---:      |:---:|
|name       |string     |yes        |     |
|interanl   |bool       |yes        |     |
|enable_deletion_protection | bool | no | default : false |
|enable_cross_zone_load_balancing | bool | no | default : false | 
|tags       |map(string) | no       |     | 


```
Terraform
```