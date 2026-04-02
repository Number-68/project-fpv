**Project FPV — Agile Full‑Stack Mock Ecommerce Website**

Project FPV is a mock ecommerce application built for my **Agile Full Stack Development** course.  
The goal of this project is to simulate a real full‑stack workflow using modern Rails conventions, third‑party integrations, and automated data ingestion.

This repository represents the full lifecycle of a small ecommerce platform — from scraping product data, to building a storefront, to integrating payments and admin tooling.

---

## **Features**

### **Automated Drone Product Scraper**
This project includes a custom scraper that uses **HTTParty** and **Kaminari** to pull product data from:

https://epicfpv.ca

The scraper:
- Crawls **every category and subcategory** on the site’s first page  
- Extracts product names, prices, images, and metadata  
- Seeds the local database with realistic ecommerce data  

Run it with:

```
rails db:seed
```

---

### **Admin Dashboard (ActiveAdmin)**
An admin console is included for:
- Managing products  
- Viewing orders  
- Overseeing users  
- Monitoring Stripe transactions  

Accessible at:

```
/admin
```

(Requires admin credentials created in your seeds or manually.)

---

### **Stripe Payment Integration**
The checkout flow uses **Stripe** for secure payment processing.

For security reasons, **no Stripe API keys are included in this repository**.  
To run payments locally, you must provide your own credentials:

```
STRIPE_PUBLISHABLE_KEY=your_key_here
STRIPE_SECRET_KEY=your_key_here
```

Add them to your `.env` or Rails credentials depending on your setup.

---

## **Getting Started**

### **1. Install dependencies**
```
bundle install
```

### **2. Set up the database**
```
rails db:create
rails db:migrate
rails db:seed
```

### **3. Start the server**
```
bin/dev
```
or
```
rails server
```

### **4. Visit the site**
```
http://localhost:3000
```

---

## **Project Purpose**
This project demonstrates:
- Agile development workflow  
- Full‑stack Rails architecture  
- Real‑world data ingestion  
- Payment integration  
- Admin tooling  
- Ecommerce UX patterns  

It is not intended for production use — it’s a learning tool that mirrors real full‑stack processes.

---

## **License**
This project is for educational use only.