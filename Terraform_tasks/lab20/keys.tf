resource "tls_private_key" "key_pair" {
  count     = 2
  algorithm = "RSA"
  rsa_bits  = 2048
}
# Public Key File
resource "local_file" "public_key_file" {
  count   = 2
  content = tls_private_key.key_pair[count.index].public_key_openssh
  filename = "lab20_key_${count.index == 0 ? "primary" : "secondary"}_public.pem" # Adjusted file names
}

# Private Key File
resource "local_file" "private_key_file" {
  count   = 2
  content = tls_private_key.key_pair[count.index].private_key_pem
  filename = "lab20_key_${count.index == 0 ? "primary" : "secondary"}_private.pem" # Adjusted file names
}
resource "aws_key_pair" "lab20_key_pair" {
  count      = 2
  key_name   = "lab20_key_${count.index == 0 ? "primary" : "secondary"}" # Adjusted key names
  public_key = tls_private_key.key_pair[count.index].public_key_openssh
}
