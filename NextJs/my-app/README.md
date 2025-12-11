# Next.js App (Bun + Docker) — README

This project is a **Next.js 16 application** using **React 19**, built and run using **Bun** and containerized using Docker.

---

## 🚀 Tech Stack

* **Next.js 16**
* **React 19**
* **Bun** (for runtime & build)
* **Docker** (multi‑stage build)
* **TailwindCSS 4**
* **TypeScript 5**

---

## 📂 Project Structure

```
my-app/
├── package.json
├── Dockerfile
├── public/
├── pages/ or app/
├── styles/
└── ...other files
```

---

## 🏃 Run Locally (Without Docker)

### **Requirements**

* Bun installed → [https://bun.sh](https://bun.sh)

### **Install dependencies**

```bash
bun install
```

### **Start development server**

```bash
bun run dev
```

Runs at: **[http://localhost:3000](http://localhost:3000)**

### **Build production build**

```bash
bun run build
```

### **Start production mode**

```bash
bun run start
```

---

## 🐳 Run Using Docker

### **Build Docker image**

```bash
docker build -t my-next-app .
```

### **Run container**

```bash
docker run -p 3000:3000 my-next-app
```

App will be available at:
**[http://localhost:3000](http://localhost:3000)**

---

## 📦 Dockerfile Overview

* **Stage 1 (build):**

  * Uses `oven/bun:1`
  * Installs dependencies via Bun
  * Builds the Next.js production build

* **Stage 2 (runner):**

  * Copies `.next`, `node_modules`, and `public` from build stage
  * Starts server using:

    ```bash
    bun run next start
    ```

---

## ⚠️ Important Notes

### 1. **Bun + Next.js Compatibility**

Next.js 16 runs well on Bun runtime, but some Node APIs may behave differently.

### 2. **You must commit `bun.lockb`**

`bun install` uses lockfile to ensure reproducible builds.

### 3. **Ensure `.dockerignore` exists**

Recommended:

```
node_modules
.next
.git
Dockerfile
*.log
```

### 4. **Environment Variables**

Add environment variables in:

* `.env.local` (local dev)
* With Docker:

```bash
docker run -p 3000:3000 -e API_URL=https://example.com my-next-app
```

---

## 📘 Scripts Reference

| Command         | Description               |
| --------------- | ------------------------- |
| `bun run dev`   | Start development server  |
| `bun run build` | Build production bundle   |
| `bun run start` | Run Next.js in production |

---

## 📮 Contact / Issues

If you run into problems, check:

* Bun docs: [https://bun.sh/docs](https://bun.sh/docs)
* Next.js docs: [https://nextjs.org/docs](https://nextjs.org/docs)

Feel free to ask for help or enhancements! 🚀

