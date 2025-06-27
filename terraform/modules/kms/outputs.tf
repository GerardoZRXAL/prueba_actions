output "kms_keys_data" {
  description = "Data for the creation of the keys in AWS KMS"
  value       = aws_kms_key.kms_key
}