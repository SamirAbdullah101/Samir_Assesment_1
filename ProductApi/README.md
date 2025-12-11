# .NET 8 Web API — README

This project is a **.NET 8 Minimal API** including Swagger/OpenAPI support, packaged and deployed using a multi-stage **Docker** build.

---

## 🚀 Tech Stack

* **.NET 8 (ASP.NET Core Minimal API)**
* **Swagger / Swashbuckle** for API documentation
* **Docker (multi‑stage build)**

---

## 📂 Project Structure

```
ProductApi/
├── Program.cs
├── ProductApi.csproj
├── appsettings.json
├── appsettings.Development.json
├── Dockerfile
├── Properties/
│   └── launchSettings.json
├── bin/
├── obj/
└── ProductApi.http
```

---

## 🏃 Run Locally (Without Docker)

### **Requirements**

* .NET 8 SDK → [https://dotnet.microsoft.com](https://dotnet.microsoft.com)

### **Restore dependencies**

```bash
dotnet restore
```

### **Run the API**

```bash
dotnet run
```

The API runs at:

```
http://localhost:5122/weatherforecast
```

[http://localhost:5122](http://localhost:5122)

```

### **Access Swagger UI**
```

[http://localhost:5122/swagger](http://localhost:5122/swagger)

````

> Swagger loads only when `ASPNETCORE_ENVIRONMENT=Development`

### **Build Release version**
```bash
dotnet build -c Release
````

### **Publish Release output**

```bash
dotnet publish -c Release -o ./publish
```

---

## 🐳 Run Using Docker

### **Build Docker Image**

```bash
docker build -t product-api .
```

### **Run Container**

```bash
docker run -p 8080:8080 product-api
```

API will be available at:

```
http://localhost:8080/weatherforecast
```

[http://localhost:8080](http://localhost:8080)

````

### **Swagger inside Docker**
⚠️ Swagger UI appears only when environment = Development.

Override inside Docker with:
```bash
docker run -p 8080:8080 -e ASPNETCORE_ENVIRONMENT=Development product-api
````

Then visit:

```
http://localhost:8080/swagger
```

---

## 📦 Dockerfile Overview

### **Stage 1 — Build**

* Uses: `mcr.microsoft.com/dotnet/sdk:8.0`
* Restores NuGet packages
* Builds and publishes the app

### **Stage 2 — Runtime**

* Uses lightweight: `mcr.microsoft.com/dotnet/aspnet:8.0`
* Copies published output
* Exposes port **8080**
* Runs the application:

```
dotnet ProductApi.dll
```

---

## ⚠️ Important Notes

### 1. **Swagger only in Development mode**

For production, you must manually enable or configure Swagger.

### 2. **HTTPS disabled in Docker**

The container only exposes HTTP (`8080`).

### 3. **Environment variables**

Set via:

```bash
docker run -e "Key=Value" product-api
```

### 4. **Use ProductApi.http for testing**

You can test endpoints via VS Code or curl.

Example:

```bash
curl http://localhost:8080/weatherforecast
```

---

## 📮 Troubleshooting

* If Swagger doesn't load → ensure environment is Development.
* If the app crashes in Docker → check logs:

```bash
docker logs <container_id>
```

---

If you want, I can also create:

* `docker-compose.yml`
* Production-ready environment variable examples
* CI/CD pipeline (GitHub Actions / GitLab)
* Deployment instructions for AWS / Azure / DigitalOcean

