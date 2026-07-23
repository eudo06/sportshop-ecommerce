# SportShop - Full-Stack E-commerce App

SportShop is a full-stack e-commerce application for sports equipment. It includes a Vue 3 storefront, an Express REST API, JWT authentication, product browsing, cart management, order creation, ratings, stock checks, and an admin area for managing products and users.

## Features

- Product catalog with categories, search, price filters, discounts, stock, colors, and sizes
- User registration and login with JWT authentication
- Authenticated cart with quantity updates and item removal
- Checkout flow with transactional stock validation
- Product ratings
- Admin dashboard for product creation, update, deletion, and user banning/unbanning
- MySQL database export with demo data

## Tech Stack

- Frontend: Vue 3, Vite, Vue Router, Pinia, Axios
- Backend: Node.js, Express.js, REST API
- Database: MySQL
- Authentication: JWT, bcrypt password hashing

## Project Structure

```text
.
├── backend/              # Express API, routes, controllers, models
├── database/             # MySQL schema and demo data export
├── frontend-vue/         # Vue 3 frontend
├── package.json          # Backend scripts and dependencies
└── README.md
```

## Getting Started

### Prerequisites

- Node.js and npm
- MySQL running locally

### 1. Install Dependencies

```bash
npm install
cd frontend-vue
npm install
cd ..
```

### 2. Configure Environment Variables

Create the backend environment file:

```bash
cp backend/.env.example backend/.env
```

Update `backend/.env` with your MySQL credentials and a strong `JWT_SECRET`.

Create the frontend environment file:

```bash
cp frontend-vue/.env.example frontend-vue/.env
```

By default, the frontend expects the API at:

```bash
VITE_API_URL=http://localhost:5001/api
```

### 3. Import the Database

The export creates and seeds the `ecommerce_db` database:

```bash
mysql -u root -p < database/ecommerce_db_export.sql
```

If your local MySQL user does not require a password:

```bash
mysql < database/ecommerce_db_export.sql
```

### 4. Run the Application

Start the backend:

```bash
npm run dev
```

Start the frontend in another terminal:

```bash
npm run client
```

Build the frontend:

```bash
npm run client:build
```

## Demo Admin Account

- Email: `admin@example.com`
- Password: `admin123`

This account is only for local demo usage.

## Database Export

To refresh the SQL export after changing local demo data:

```bash
cd database
./export_database.sh
```

## Notes

Real `.env` files, `node_modules`, production builds, logs, and OS metadata are excluded from Git. Use the example environment files as templates.
