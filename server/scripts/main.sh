#!/bin/bash -x

function asksure() {
  echo "$1"
  while read -r answer; do
    if [[ $answer = [YyNn] ]]; then
      [[ $answer = [Yy] ]] && retval=0
      [[ $answer = [Nn] ]] && retval=1
      break
    fi
  done

  return ${retval}
}

terraform -chdir=server/terraform/foundation init
terraform -chdir=server/terraform/project init
# Ajustra las configuraciones de red
terraform -chdir=server/terraform/foundation apply

# Destruir la maquina anterior
terraform -chdir=server/terraform/project destroy
# Crear una nueva maquina
terraform -chdir=server/terraform/project apply

if asksure '¿Quiere configurar su máquina? ¿Ya esta prendida? (Y/N)?'; then
  # Borrarla de known_hosts
  ssh-keygen -f "${HOME}/.ssh/known_hosts" -R 'appbajopruebas.com' || ( echo 'no se puede continuar' && exit 1)
  scp -i ~/.ssh/id_rsa docker-compose.yml root@appbajopruebas.com:~
  ssh -i ~/.ssh/id_rsa root@appbajopruebas.com 'bash -s' < server/scripts/install-app.sh || ( echo 'no se puede instalar el sw' && exit 2)
fi

exit 0
