#!/bin/zsh

# Function to display error message and exit
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Function to install Terraform
install_terraform() {
    echo "Installing Terraform..."
    # Check if Terraform is already installed
    if command -v terraform &> /dev/null; then
        error_exit "Terraform is already installed."
    fi

    # Download Terraform binary
    curl -fsSL https://releases.hashicorp.com/terraform/$(curl -s https://releases.hashicorp.com/terraform/ | grep -Eo 
'[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)/terraform_$(curl -s https://releases.hashicorp.com/terraform/ | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | 
head -n 1)_linux_amd64.zip -o terraform.zip || error_exit "Failed to download Terraform binary."
    # Unzip Terraform binary
    unzip terraform.zip || error_exit "Failed to unzip Terraform binary."
    # Move Terraform binary to /usr/local/bin directory
    sudo mv terraform /usr/local/bin || error_exit "Failed to move Terraform binary."
    # Remove downloaded zip file
    rm terraform.zip || error_exit "Failed to remove downloaded zip file."
    echo "Terraform installation completed."
}

configure_terraform() {
    echo "Configuring Terraform..."
    # Check if Terraform is installed
    if ! command -v terraform &> /dev/null; then
        error_exit "Terraform is not installed."
    fi

    echo "Do you want to initialize Terraform configuration? (y/n)"
    read -r init_choice
    if [ "$init_choice" = "y" ]; then
        terraform init || error_exit "Failed to initialize Terraform configuration."
        echo "Terraform configuration initialized."
    fi

    # Verify Terraform installation and version
    terraform --version || error_exit "Failed to verify Terraform installation."
}

main() {
    install_terraform
    configure_terraform
}

main

