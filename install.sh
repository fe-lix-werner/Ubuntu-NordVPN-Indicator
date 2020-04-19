#!/bin/bash


install_indicator()
{
    # Installing indicator in opt directory
    echo "Installing Ubuntu NordVPN Indicator"
    sudo mkdir -p /opt/ubuntu-nordvpn-indicator/
    sudo cp code/* /opt/ubuntu-nordvpn-indicator/

    # Installing autostart desktop file
    echo "Making sure the indicator starts at boot using autostart"
    mkdir -p $HOME/.config/autostart
    cp ubuntu-nordvpn-indicator.desktop $HOME/.config/autostart/
}

install_deps()
{
    # Install gir1.2-appindicator
    echo "Installing AppIndicator and Python-GI"
    sudo apt-get install -y gir1.2-appindicator python-gi
}


# Install indicator
install_indicator

# Install dependencies if not present
deps_available=$(dpkg -l | grep -E "gir1.2-appindicator-|python-gi"  | wc --lines)
if [[ $deps_available -eq 2 ]]
then
    echo "Dependencies have been installed"
else
    install_deps
fi
# Starting script
if pgrep -f "nordvpn_indicator" > /dev/null
then
    echo "Killing indicator"
    kill $(pgrep -f "nordvpn_indicator")
fi

echo "Starting indicator"
nohup $(command -v python) /opt/ubuntu-nordvpn-indicator/nordvpn_indicator.py >/dev/null 2>&1 &

echo "Finished"
