## Using disposable ssh keys with age in devcontainers

When running in a dev container, the ssh private keys are not easily available.
I am generating a new key within the dev container and add my SSH keys as
recipients. This way even if the dev container is rebuilt I can always use one
of my computers to decrypt the secrets, generate a new key in the new container
and re-encrypt the secrets.

```
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519
mkdir -p ~/.config/sops/age
ssh-to-age -private-key -i ~/.ssh/id_ed25519 >> ~/.config/sops/age/keys.txt
```

## Fetch ssh host pub key

```
ssh-keyscan -t ed25519 erp1.home.kyrych.uk | sed "s/^[^ ]* //" > hosts/erp1/ssh_host_ed25519_key.pub
```
