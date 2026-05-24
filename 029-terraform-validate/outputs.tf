output "file_path" {
  description = "Path to the generated file"
  value       = local_file.example.filename
}

output "file_content" {
  description = "Content written to the file"
  value       = local_file.example.content
}
