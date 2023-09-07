resource "aws_key_pair" "onephras_key" {
  key_name   = "onephrase-key"  
  public_key = file(var.keypair_path)  # Caminho para o arquivo de chave pública SSH local
}