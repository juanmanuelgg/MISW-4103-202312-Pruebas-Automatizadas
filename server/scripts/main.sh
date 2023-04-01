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

terraform -chdir=server/terraform/project init
terraform -chdir=server/terraform/foundation init
# Destruir la maquina anterior
terraform -chdir=server/terraform/project destroy
# Crear una nueva maquina
terraform -chdir=server/terraform/project apply
# Ajustra las configuraciones de red
terraform -chdir=server/terraform/foundation apply

if asksure '¿Quiere configurar su máquina? ¿Ya esta prendida? (Y/N)?'; then
  # Borrarla de known_hosts
  ssh-keygen -f "${HOME}/.ssh/known_hosts" -R 'appbajopruebas.com' || ( echo 'no se puede continuar' && exit 1)
  ssh -i ~/.ssh/do_rsa root@appbajopruebas.com 'bash -s' < install-app.sh -a || ( echo 'no se puede instalar el sw' && exit 2)
fi

exit 0
