echo "Setting up the project..."

# Get the folder path of this script independent of where it is called from
PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create a cron job to backup the database every 2 minutes
echo "Creating a cron job to backup the database every 2 minutes..."

crontab -l | { cat; echo "* * * * * exec $PWD/dump_databases.sh"; } | crontab - 

# Add a empty infinite loop to keep the container running
echo "Press [CTRL+C] to stop the server."
while true; do sleep 1000; done