# Emacs
sudo add-apt-repository ppa:kelleyk/emacs
> see https://github.com/kelleyk/ppa-emacs for more
# Pacstall (AUR Like for Ubuntu deriv)
- https://pacstall.dev/
# Nala (frontend apt) with nice ui
- 

# Brave
```shell
sudo apt install apt-transport-https curl

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install brave-browser
```

# Building from source requirement
- autoconf
- \*.-dev (contain C header files)


# Packages
- htim (htop with vim keybinding)

# Virtualbox
- virtualbox
- virtualbox-ext-pack
- virtualbox-guest-additions-iso


## Emacs
-

## Spotify
```
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo tee /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt-get update && sudo apt-get install spotify-client

```
## gnome-shell
