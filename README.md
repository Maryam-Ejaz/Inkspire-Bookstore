# Inkspire - A Simple Mock Book Store

**Inkspire** is a simple mock book store application designed to offer a smooth and engaging user experience. The app showcases a variety of books and integrates essential functionalities like cart management and search features. It takes product data from a JSON file and manages the shopping cart using SQLite.

## Features

- **Product Data Integration:** Product information is loaded from a JSON file, including details like name, price, description, and images.
- **Cart Management:** Users can add, remove, and manage items in their cart using SQLite for persistent storage.
- **Search Functionality:** An integrated search feature allows users to quickly find books by their titles or descriptions.

## Screens

### 1. Home Screen
- **Description:** Displays a list of products organized by categories.
- **Features:** 
  - Displays product grid with book details and images.
  - A search bar for finding specific books.
  - Category tabs for filtering products.
  - Navigation to the cart screen.

### 2. Product Detail Page
- **Description:** Provides detailed information about a selected book.
- **Features:** 
  - Displays book description, price, and images.
  - Option to add the book to the cart.

### 3. Cart Screen
- **Description:** Allows users to view and manage their cart.
- **Features:** 
  - Lists items in the cart with options to adjust quantities.
  - Displays total price.
  - Button to proceed to checkout.

### 4. Checkout Screen
- **Description:** Facilitates the checkout process.
- **Features:**
  - Collects user details for order completion.
  - Provides a summary of items in the cart.
  - Option to confirm purchase.

### 5. Thank You Screen
- **Description:** Shows a confirmation message after a successful purchase.
- **Features:** 
  - Displays a thank you message and order details.

## Technical Details

- **Data Management:** Product data is read from a JSON file (`assets/Products/products.json`).
- **Cart Management:** Uses SQLite for storing cart data and handling operations like adding and removing items.
- **Search Feature:** Allows users to search for books by title or description, enhancing user experience and usability.
