  resource "local_file" "example" {
   filename = "${path.module}/test.txt"
content = "hello"
}
