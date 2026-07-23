# Database

Use `ecommerce_db_export.sql` to create and seed the local MySQL database.

```bash
mysql -u root -p < database/ecommerce_db_export.sql
```

The seed includes product/category demo data and one local admin account:

- Email: `admin@example.com`
- Password: `admin123`

No real user data should be committed to this folder.
