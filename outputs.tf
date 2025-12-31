output "azure-local-virtualmachineinstance-admin-password" {
  value     = random_string.azure-local-virtualmachineinstance-admin-password.result
  sensitive = true
}