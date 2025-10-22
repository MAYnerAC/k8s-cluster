k8s-cluster

### Comandos

| Comando          | Qué hace                                                                 |
|------------------|--------------------------------------------------------------------------|
| `vagrant init`   | Crea un archivo `Vagrantfile` en el directorio actual.                   |
| `vagrant up`     | Crea (si no existe) y arranca la VM; provisiona si es la primera vez.   |
| `vagrant halt`   | Apaga la máquina virtual (como un apagado normal).                      |
| `vagrant destroy`| Elimina la VM y todos sus archivos (borrado completo).                  |
| `vagrant ssh`    | Abre una conexión SSH a la VM para usar la consola dentro de la máquina.|
| `vagrant status` | Muestra el estado actual de la(s) VM(s).                                |


---


| Comando          | Qué hace                                                                 |
|------------------|--------------------------------------------------------------------------|
| `vagrant suspend`| Suspende la VM (pausa su estado para reanudarla más rápido).            |
| `vagrant resume` | Reanuda una VM suspendida.                                               |
| `vagrant reload` | Reinicia la VM y recarga la configuración del `Vagrantfile`.            |

vagrant reload --provision


---

### Discover Vagrant Boxes

https://portal.cloud.hashicorp.com/vagrant/discover

#### generic/debian12

---
| Box Name           | Debian Version          | Comentarios                                                  |
|--------------------|------------------------|--------------------------------------------------------------|
| generic/debian12   | 12 (Bookworm)           | Mejor opción actual, base Debian 12 oficial, buena compatibilidad, mantenida |
| debian/bullseye64  | 11 (Bullseye)           | Debian 11 oficial, estable, buena opción si no necesitas 12   |
| generic/debian11   | 11 (Bullseye)           | Otra variante mantenida para Debian 11, buena opción también  |
| debian/buster64    | 10 (Buster)             | Debian 10, estable pero próximo a fin de soporte, no recomendado para nuevos proyectos |

debian/bookworm64

---

#### ubuntu/focal64

| Box Name        | Ubuntu Version     | Comentarios                                      |
|-----------------|--------------------|-------------------------------------------------|
| ubuntu/focal64   | 20.04 LTS (Focal)  | Más reciente que bionic, mejor soporte y actualizaciones |
| ubuntu/bionic64  | 18.04 LTS (Bionic) | Versión estable, muy usada, buen soporte LTS    |


---


