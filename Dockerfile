FROM mcr.microsoft.com/mssql/server:2019-latest
USER root

# Copy the SQL script into the container
COPY init.sql /usr/src/app/init.sql

# Copy the entrypoint script
COPY init.sh /usr/src/app/init.sh
RUN chmod +x /usr/src/app/init.sh

# Set the entrypoint to the custom script
ENTRYPOINT ["sh", "/usr/src/app/init.sh"]
#CMD /usr/src/app/init.sh
