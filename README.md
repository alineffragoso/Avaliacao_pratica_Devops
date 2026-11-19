# Infraestrutura como Código e Automação: Aplicação Livraria (2 VMs)

Projeto desenvolvido para provisionamento automatizado de infraestrutura virtualizada com **OpenTofu (Libvirt/KVM)** e configuração de serviços conteinerizados com **Ansible** e **Docker**.

## Integrantes do Grupo
* **Aline de Souza Fragoso**
* **Gabrielly Simão Domingos**
* **Vinicius Felipe Tesser**

## Arquitetura e Endereços de Acesso
* **Aplicação Web (Frontend Nginx):** `[http://192.168.122.176](http://192.168.122.176)` (`vm1-app-web`, porta `80`)
* **API REST & Banco de Dados (Node.js + MySQL 8.0):** `[http://192.168.122.43:3000/livros](http://192.168.122.43:3000/livros)` (`vm2-api-banco`, porta `3000`)

## Instruções de Execução

1. **Provisionar as Máquinas Virtuais com OpenTofu:**
   ```bash
   cd iac
   tofu init
   tofu apply -auto-approve
   ```

2. **Configurar os Contêineres e Serviços com Ansible:**
   ```bash
   cd ../ansible
   ansible-playbook -i inventory playbook.yml
   ```

3. **Acessar e Validar a Aplicação:**
   * Abra o navegador no endereço da aplicação web: **`[http://192.168.122.176](http://192.168.122.176)`**
   * Para testar diretamente o endpoint da API:
     ```bash
     curl http://192.168.122.43:3000/livros
     ```
