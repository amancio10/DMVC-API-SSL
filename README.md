# DMVC-API-SSL
 Api com certificado SSL em Delphi MVC

## ⚡️ Preparação do ambiente de desenvolvimento
1.	Instale o OpenSSL 32x e 64x em seu ambiente, isso garante que os sistemas dependentes desses recursos funcionem corretamente (recomendado todas as instalações serem feitas sempre como administrador).

<img align="center" alt="OpenSSL" height="200" width="500" src="https://github.com/amancio10/DMVC-API-SSL/assets/48102777/e5406571-0042-47e5-a65a-94864792ed4a">

https://slproweb.com/products/Win32OpenSSL.html

2.	Informe as variáveis de ambiente no sistema operacional:
<img align="center" alt="variáveis de ambiente" height="250" width="500" src="https://github.com/amancio10/DMVC-API-SSL/assets/48102777/7658bb95-e501-4f28-a48b-f060d63e8ea9">

<img align="center" alt="variáveis de ambiente" height="250" width="250" src="https://github.com/amancio10/DMVC-API-SSL/assets/48102777/25f587ef-7df5-4501-b6c5-5497729f8c50">

4.	Reinicie sua maquina.
5.	Instale o Apache
<img align="center" alt="Apache" height="200" width="500" src="https://github.com/amancio10/DMVC-API-SSL/assets/48102777/6ee88061-c855-47c2-a789-be71e81a82f1">

https://www.apachelounge.com/download/

## ⚡️ Gerando o certificado SSL local
1.	Na pasta de instalação do seu DMVC, no caminho [...]/delphimvcframework-darnocian-sempare_adaptor_support\samples\sslserver
Você vai encontra um arquivo chamado GENERATE_CERTIFICATES.bat
Edite-o para mudar o caminho onde você instalou o Apache

<img align="center" alt="Apache" height="250" width="500" src="https://github.com/amancio10/DMVC-API-SSL/assets/48102777/a225b314-edb5-48fe-85ca-5ec2caea02b4">

2.	Abra o CMD como administrador
3.	Use o comando CD + caminho para navegar até a pasta do GENERATE_CERTIFICATES.bat
<img align="center" alt="CMD" height="250" width="500" src="https://github.com/amancio10/DMVC-API-SSL/assets/48102777/1393974c-5661-4780-8713-110b8dd7ee63">

4. Em seguida execute o GENERATE_CERTIFICATES.bat

<img align="center" alt="GENERATE_CERTIFICATES" height="250" width="500" src="https://github.com/amancio10/DMVC-API-SSL/assets/48102777/90dc5f48-fae8-40e5-be45-3102d26ff6c2">

5.	Será criando 2 arquivos (.pem) na mesma pasta do GENERATE_CERTIFICATES.bat, esse é seu certificado.

<img align="center" alt="GENERATE_CERTIFICATES" height="100" width="300" src="https://github.com/amancio10/DMVC-API-SSL/assets/48102777/317df7bb-d00e-4f8d-8f09-8066fdcf9f50">

6.	Coloque-os na pasta do executável da sua API junto com as DLL’s: libeay32.dll & ssleay32.dll

<img align="center" alt="DLL" height="100" width="200" src="https://github.com/amancio10/DMVC-API-SSL/assets/48102777/b638f388-628b-4cfa-9041-407fbe15ce57">

## ⚡️Codificando no Delphi
1.	Na sua Procedure RunServer(APort: Integer); altere a porta para 443
 ```delphi
Procedure RunServer(APort: Integer);

RunServer(dotEnv.Env('dmvc.server.port', 443));  // SSL
```
2.	Em uses adicione IdSSLOpenSSL
 ```delphi
uses
  IdSSLOpenSSL
 ```
3.	Ainda em Procedure RunServer(APort: Integer); adicione a variável LIOHanldeSSL e as seguintes linhas de códigos
```delphi
procedure RunServer(APort: Integer);
var
 LIOHanldeSSL : TIdServerIOHandlerSSLOpenSSL; // SSL
 ```
```delphi
begin
  try
   LIOHanldeSSL := TIdServerIOHandlerSSLOpenSSL.Create(LServer); // SSL
   LIOHanldeSSL.SSLOptions.CertFile := 'cacert.pem';             // SSL
   LIOHanldeSSL.SSLOptions.KeyFile  := 'privkey.pem';            // SSL
   LServer.IOHandler := LIOHanldeSSL;                            // SSL
```
## ⚡️Testando no Postman
Abra o Postman e execute o EndPoint https://localhost/api/customers/1

<img align="center" alt="Postman" height="250" width="500" src="https://github.com/amancio10/DMVC-API-SSL/assets/48102777/492d2e56-3878-429e-9a47-18204cac1059">

