# ⚡ MahuaXpress — Blinkit Clone (Flutter & Dart)

A production-ready, pixel-perfect **Blinkit Clone** built with **Flutter & Dart**, featuring identical UI/UX, authentic 10-minute quick-commerce architecture, integrated **Dark Store Admin Console**, real-time order tracking with animated route map, and local persistence.

Reverse-engineered and architected using **`rea@6.5.0`** (Reverse Engineer Anything).

---

## 📸 Screenshots & UX Highlights

| Home & 10-Min Header | 2-Pane Category Split | Live Order Tracking & Map | Admin Console |
| :---: | :---: | :---: | :---: |
| ⚡ Iconic Blinkit Yellow Header with ETA & Address Switcher | 🥛 Left Rail Categories + Sub-category Grid | 🛵 Animated Delivery Rider with OTP & Live Stepper | 📊 Revenue, Product Catalog & Live Dispatch |

---

## ✨ Features

### 🛒 1. Customer Storefront & Quick Commerce
- **Signature Blinkit Header**:
  - Live **"⚡ 9 MINS"** delivery badge.
  - Interactive **Location Selector Bottom Sheet** to switch or add delivery addresses.
  - Search trigger with animated placeholder prompts (*"Search milk, bread, chips..."*).
- **Dynamic Content Feed**:
  - Auto-scrolling **Promotional Banners Carousel** with gradient cards and indicator dots.
  - **Category Grid** across 11+ departments (Dairy, Veggies, Munchies, Drinks, Instant Food, Atta & Dal, etc.).
  - **Bestsellers Carousel** at lowest discounted prices.
- **2-Pane Category Explorer**:
  - Desktop/tablet & mobile split view with a left vertical category rail and right subcategory filter chips + product grid.
- **Micro-Animated "ADD" Button**:
  - Clean white button with emerald green border and text.
  - Instantly transforms into an animated `[-] [qty] [+]` stepper on tap.
- **Sticky Floating Cart Bar**:
  - Slides up whenever items are added (`3 ITEMS • ₹185 • Saved ₹35 | View Cart ➔`).
- **Comprehensive Checkout & Bill Details**:
  - Item breakdown, delivery fee (FREE above ₹199), handling fee, and **delivery partner tip selector** (₹10, ₹20, ₹30, ₹50).
  - Green savings banner highlighting total discount.
- **Payment Gateway Simulation**:
  - UPI (Google Pay, PhonePe, Paytm), Credit/Debit Cards, Net Banking, and Cash on Delivery (COD).

### 🗺️ 2. Real-Time Live Order Tracking
- **Animated Map Canvas**:
  - Visual simulated map with dark store origin, customer destination, and an animated electric delivery bike moving along a bezier route.
  - Pulse radar animation around the delivery partner.
- **4-Digit Delivery OTP**: Displayed prominently for secure delivery handoff.
- **Rider Contact Card**: Rider name, electric vehicle registration, ratings, and one-tap call button.
- **Live 4-Stage Stepper**:
  1. `Order Placed & Confirmed`
  2. `Packing Fresh Essentials at Dark Store`
  3. `Out for Delivery`
  4. `Delivered at Doorstep`
- **Auto-Progression & Quick Testing Controls**: Watch order transition in real time or trigger manual status changes directly from the screen.

### 👨‍💼 3. Integrated Dark Store Admin Console
Switch anytime between Customer Mode and Store Manager Mode via the Profile tab:
- **Real-Time Analytics Dashboard**:
  - Total Store Revenue (₹), Active Deliveries, Total Orders, and Catalog Count.
  - Low stock warning alerts.
- **Product Catalog Management**:
  - Search and filter products by category.
  - Toggle **In Stock / Out of Stock** with instant customer storefront sync.
  - Edit pricing, MRP, pack size/unit, stock count, and bestseller flags.
  - **Add New Product**: Form with Unsplash grocery image presets or custom CDN URLs.
- **Live Dispatch Manager**:
  - View all incoming orders.
  - Advance status (`Placed` ➔ `Packing` ➔ `Out for Delivery` ➔ `Delivered`).
  - **Live Synchronization**: Updates made in Admin immediately reflect on the customer's live tracking screen!

### 💾 4. Persistence
- Local storage using `shared_preferences` for products, custom additions, cart items, delivery addresses, and past order history.

---

## 🏗️ Architecture & Project Structure

```
MahuaXpress/
├── lib/
│   ├── main.dart                          # App entry point & MultiProvider setup
│   ├── constants/
│   │   ├── app_colors.dart                # Blinkit brand palette (#F7D300, #0C831F, etc.)
│   │   ├── app_theme.dart                 # Google Fonts (Inter) typography & widget themes
│   │   └── mock_data.dart                 # 30+ realistic Indian grocery items & categories
│   ├── models/
│   │   ├── product_model.dart             # Product data & discount calculation
│   │   ├── category_model.dart            # Category definitions & emoji icons
│   │   ├── cart_item_model.dart           # Cart item with price multipliers
│   │   ├── order_model.dart               # Order status, rider details & OTP
│   │   └── user_address_model.dart        # Saved addresses (Home, Work, Other)
│   ├── providers/
│   │   ├── app_provider.dart              # Catalog, addresses & admin mode state
│   │   ├── cart_provider.dart             # Cart items, tips & bill calculation
│   │   └── order_provider.dart            # Order creation & live progress simulation
│   ├── screens/
│   │   ├── splash_screen.dart             # Animated Blinkit splash
│   │   ├── main_navigation_screen.dart    # 4-tab bottom navigation shell
│   │   ├── home/
│   │   │   ├── home_screen.dart           # Hero feed, categories & carousels
│   │   │   ├── search_screen.dart         # Instant search with trending tags
│   │   │   └── address_bottom_sheet.dart  # Address picker & new address form
│   │   ├── category/
│   │   │   └── category_screen.dart       # Split 2-pane category browser
│   │   ├── product/
│   │   │   └── product_detail_screen.dart # Highlights, image preview & guarantees
│   │   ├── cart/
│   │   │   ├── cart_screen.dart           # Bill breakdown & checkout
│   │   │   └── payment_screen.dart        # UPI, Card, NetBanking & COD payment
│   │   ├── order/
│   │   │   ├── order_tracking_screen.dart # Live map & 9-minute countdown
│   │   │   └── order_history_screen.dart  # Past order receipts & reorder action
│   │   ├── profile/
│   │   │   └── profile_screen.dart        # User account & Admin Console launcher
│   │   └── admin/
│   │       ├── admin_dashboard_screen.dart        # Store analytics & shortcuts
│   │       ├── admin_products_screen.dart         # Catalog stock & CRUD
│   │       ├── admin_add_edit_product_screen.dart # Add/edit product form
│   │       └── admin_orders_screen.dart           # Dispatch controller
│   └── widgets/
│       ├── blinkit_header.dart            # Yellow top bar with location pill
│       ├── banner_carousel.dart           # Gradient promotional slides
│       ├── category_chip.dart             # Emoji category tile
│       ├── product_card.dart              # Product card with discount badge
│       ├── quantity_button.dart           # Animated ADD / counter stepper
│       ├── floating_cart_bar.dart         # Sticky bottom cart bar
│       └── live_map_widget.dart           # Canvas painter with route & bike
├── test/
│   └── widget_test.dart                   # Automated smoke & transition tests
├── .github/
│   └── workflows/
│       └── flutter.yml                    # Automated GitHub Actions CI workflow
├── pubspec.yaml                           # Dependencies & assets configuration
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.41.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.11.0`)
- Android Studio / VS Code / Google Chrome

### Run Locally

1. **Clone repository**:
   ```bash
   git clone https://github.com/<your-username>/MahuaXpress.git
   cd MahuaXpress
   ```

2. **Get dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify code quality**:
   ```bash
   flutter analyze
   flutter test
   ```

4. **Launch the application**:
   - **Chrome / Web**:
     ```bash
     flutter run -d chrome
     ```
   - **Windows Desktop**:
     ```bash
     flutter run -d windows
     ```
   - **Android Device / Emulator**:
     ```bash
     flutter run -d android
     ```

---

## 📤 Deploying to Your GitHub

To push this complete codebase to your own GitHub repository:

1. Create a new empty repository on [GitHub](https://github.com/new) named `MahuaXpress` (do not initialize with README or license).
2. Run the following commands from this project directory (`c:\Users\shiva\OneDrive\Documents\MahuaXpress`):

```bash
# 1. Initialize git (if not already initialized)
git init

# 2. Add all files to staging
git add .

# 3. Create your initial commit
git commit -m "feat: complete Blinkit clone (MahuaXpress) with 10-min delivery, live tracking, admin console & tests"

# 4. Set main branch
git branch -M main

# 5. Link your GitHub remote (replace with your repository URL)
git remote add origin https://github.com/<your-username>/MahuaXpress.git

# 6. Push code to GitHub
git push -u origin main
```

---

## 🛡️ License
Distributed under the MIT License. Built for educational and portfolio demonstration purposes.
