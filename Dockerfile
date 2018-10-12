# start with ArchLinux with base & base-devel
FROM base/devel

# set maintaner label
LABEL maintainer.name="Konstantin Gizdov"
LABEL maintainer.email="arch@kge.pw"

# work in /tmp
WORKDIR /tmp

USER root
## Configure initial system
# set locale to United Kingdom UTF-8
# enable gnupg for root user (for pacman)
# update keys for package signing
# update core databases
# install and configure LaTeX (TeXLive)
RUN sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
 && sed -i 's/#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen \
 && locale-gen \
 && echo 'LANG=en_GB.UTF-8' > /etc/locale.conf \
 && mkdir -p /root/.gnupg \
 && touch /root/.gnupg/dirmngr_ldapservers.conf \
 && dirmngr \
 && pacman-key --init \
 && pacman-key --populate archlinux \
 && pacman -Sy \
 && pacman --noconfirm --needed -S git freetype2 \
 && pacman --noconfirm --needed -S xorg-mkfontscale xorg-mkfontdir ttf-liberation \
 && pacman --noconfirm --needed -S biber texlive-most texlive-fontsextra \
 && ln -s /etc/fonts/conf.avail/09-texlive-fonts.conf /etc/fonts/conf.d/09-texlive-fonts.conf \
 && fc-cache && mkfontscale && mkfontdir \
 && updmap-sys \
 && texhash \
 && pacman --noconfirm --needed -S texlive-fontsextra \
 && rm -f /var/cache/pacman/pkg/* /var/lib/pacman/sync/* /etc/pacman.d/mirrorlist.pacnew

# run bash at login
CMD ["/bin/bash"]
