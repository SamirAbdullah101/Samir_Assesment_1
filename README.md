I have added separate README.md file for nextjs and dotnet project.
Please , kindly read those
systemctl part:

for dotnet project i created this service file(unit file) named newProductApi.service:
```

[Unit]
Description=.NET Web API
After=network.target

[Service]
ExecStart=/usr/bin/dotnet /home/user/Phase1/newProductApi/bin/release/net8.0/newProductApi.dll
WorkingDirectory=/home/user/Phase1/newProductApi/bin/release/net8.0
Restart=always
User=user

[Install]
WantedBy=multi-user.target

```
then run this command
sudo systemctl start newProductApi.service
then go to
http://localhost:5000/weatherforecast

for NextJs application i created this service file named my-app-nextjs

```
[Unit]
Description=NextJS Application
ConditionPathIsDirectory=/home/user/Intern/NextJs/my-app
ConditionPathExists=/snap/bin/bun
After=network.target

[Service]
ExecStartPre=/snap/bin/bun run build
ExecStart=/snap/bin/bun start
WorkingDirectory=/home/user/Intern/NextJs/my-app 
Restart=unless-stopped
User=user

[Install]
WantedBy=multi-user.target


```

then run this command
sudo systemctl start my-app-nextjs.service
then go to
http://localhost:3000/



