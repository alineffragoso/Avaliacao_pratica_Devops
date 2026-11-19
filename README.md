# Infraestrutura como Código e Automação: Aplicação Livraria (2 VMs)

Projeto desenvolvido para provisionamento automatizado de infraestrutura virtualizada com **OpenTofu (Libvirt/KVM)** e configuração de serviços conteinerizados com **Ansible** e **Docker**.

## Arquitetura da Solução
- **vm1-app-web (`192.168.122.176`):** Nginx servindo o frontend da Livraria na porta `80`.
- **vm2-api-banco (`192.168.122.43`):** API Node.js/Express na porta `3000` + Banco de Dados **MySQL 8.0** (configurado com `cpu { mode = "host-passthrough" }` e MAC fixo no `main.tf`).
