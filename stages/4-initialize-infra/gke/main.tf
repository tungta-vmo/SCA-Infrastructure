resource "null_resource" "module_depend_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}