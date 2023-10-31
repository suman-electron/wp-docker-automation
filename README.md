# wp-docker-automation
Welcome to WP Docker Automation, your ultimate solution for simplified WordPress deployment and management using Docker!
Install and Manage WordPress with Docker Script
This script simplifies the setup and management of WordPress sites using Docker containers. It automates the installation process, allowing you to effortlessly create, start, and stop WordPress instances.

Installation
Clone the Repository:

# git clone <repository_url>
# cd <repository_directory>

Make the Script Executable:

# chmod +x install_wordpress.sh

Usage
Create a New WordPress Site
To create a new WordPress site, run:

# ./install_wordpress.sh create example.com

Replace example.com with your desired site name.

Start an Existing WordPress Site
To start an existing WordPress site, use:

# ./install_wordpress.sh start example.com

Replace example.com with your site name.

Stop a Running WordPress Site
To stop a running WordPress site, execute:

# ./install_wordpress.sh stop example.com

Replace example.com with your site name.

Additional Notes
The script automatically handles the installation of Docker and Docker Compose if they are not already installed on your system.

After creating the WordPress site, the script prompts you to open the site in your browser. Access the site at http://example.com:8080 (replace example.com with your site name).

Ensure port 8080 is available and not used by other applications before running the script, as the WordPress site is accessible on this port.

Note: Customize the 'your_mysql_password' and 'wordpress_password' placeholders in the script with your preferred passwords before execution.

