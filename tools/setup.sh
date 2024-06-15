echo "Setting up the project..."

# Get the folder path of this script independent of where it is called from
PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create a cron job to backup the database every 2 minutes
echo "Creating a cron job to backup the database every 2 minutes..."


crontab -l | { cat; echo "* * * * * python3 $PWD/db-backup.py"; } | crontab -
crontab -l | { cat; echo "* * * * * echo 'Run this every minute' >> cron.log"; } | crontab -
