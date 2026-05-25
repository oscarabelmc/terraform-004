output "note" {
  value = "Child modules do not inherit root variables. Declare `variable \"env\" {}` in the child, then pass via module argument."
}
