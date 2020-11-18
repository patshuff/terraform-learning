provider "azuread" {
}

variable "pwd" {
  type = string
  default = "Password123"
}

variable "user_list" {
//  type = list(object({ user=string, display=string, password=string}))
  type = map
  description = "list of users to create"
//  default = [{user = "bob@test.com",display = "Bob", password = "Password.123"}]
  default = {
    "0" = ["Bob@patpatshuff.onmicrosoft.com","Bob"],
    "1" = ["Ted@patpatshuff.onmicrosoft.com","Ted"],
    "2" = ["Alice@patpatshuff.onmicrosoft.com","Alice"]
  }
}

resource "azuread_user" "new_user" {
      user_principal_name = "bill@patpatshuff.onmicrosoft.com"
      display_name = "Bill"
      password = "Password_123"
}

resource "azuread_user" "new_users" {
  for_each = var.user_list
  user_principal_name = var.user_list[each.key][0]
  display_name = var.user_list[each.key][1]
  password = var.pwd
}
