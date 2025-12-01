// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Your life Services start here`
  String get splashWord {
    return Intl.message(
      'Your life Services start here',
      name: 'splashWord',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Please enter your email`
  String get pleaseEnterYourEmail {
    return Intl.message(
      'Please enter your email',
      name: 'pleaseEnterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get pleaseEnterValidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'pleaseEnterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get pleaseEnterYourPassword {
    return Intl.message(
      'Please enter your password',
      name: 'pleaseEnterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordTooShort {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message('or', name: 'or', desc: '', args: []);
  }

  /// `Login with Google`
  String get loginWithGoogle {
    return Intl.message(
      'Login with Google',
      name: 'loginWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message('Sign Up', name: 'signup', desc: '', args: []);
  }

  /// `please Enter Your Name`
  String get pleaseEnterYourName {
    return Intl.message(
      'please Enter Your Name',
      name: 'pleaseEnterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Don't worry, just type in your email and we'll send the verification code.`
  String get forget_password_content {
    return Intl.message(
      'Don\'t worry, just type in your email and we\'ll send the verification code.',
      name: 'forget_password_content',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email...`
  String get sendOTP_error {
    return Intl.message(
      'Invalid email...',
      name: 'sendOTP_error',
      desc: '',
      args: [],
    );
  }

  /// `forget password`
  String get forget_password_title {
    return Intl.message(
      'forget password',
      name: 'forget_password_title',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Favorite`
  String get favorites {
    return Intl.message('Favorite', name: 'favorites', desc: '', args: []);
  }

  /// `OFF`
  String get discount {
    return Intl.message('OFF', name: 'discount', desc: '', args: []);
  }

  /// `Not Available`
  String get notAvailable {
    return Intl.message(
      'Not Available',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  /// `More...`
  String get more {
    return Intl.message('More...', name: 'more', desc: '', args: []);
  }

  /// `Best Seller`
  String get bestSeller {
    return Intl.message('Best Seller', name: 'bestSeller', desc: '', args: []);
  }

  /// `Latest`
  String get latest {
    return Intl.message('Latest', name: 'latest', desc: '', args: []);
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Search for a product or store`
  String get searchProductOrStore {
    return Intl.message(
      'Search for a product or store',
      name: 'searchProductOrStore',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Stores`
  String get stores {
    return Intl.message('Stores', name: 'stores', desc: '', args: []);
  }

  /// `Search category`
  String get searchCategory {
    return Intl.message(
      'Search category',
      name: 'searchCategory',
      desc: '',
      args: [],
    );
  }

  /// `Search store`
  String get searchStore {
    return Intl.message(
      'Search store',
      name: 'searchStore',
      desc: '',
      args: [],
    );
  }

  /// `Search product`
  String get searchProduct {
    return Intl.message(
      'Search product',
      name: 'searchProduct',
      desc: '',
      args: [],
    );
  }

  /// `Sort by`
  String get sortBy {
    return Intl.message('Sort by', name: 'sortBy', desc: '', args: []);
  }

  /// `Price: Low to High`
  String get priceLowToHigh {
    return Intl.message(
      'Price: Low to High',
      name: 'priceLowToHigh',
      desc: '',
      args: [],
    );
  }

  /// `Price: High to Low`
  String get priceHighToLow {
    return Intl.message(
      'Price: High to Low',
      name: 'priceHighToLow',
      desc: '',
      args: [],
    );
  }

  /// `Alphabet: A-Z`
  String get alphabetAZ {
    return Intl.message(
      'Alphabet: A-Z',
      name: 'alphabetAZ',
      desc: '',
      args: [],
    );
  }

  /// `Alphabet: Z-A`
  String get alphabetZA {
    return Intl.message(
      'Alphabet: Z-A',
      name: 'alphabetZA',
      desc: '',
      args: [],
    );
  }

  /// `Filter by price`
  String get filterByPrice {
    return Intl.message(
      'Filter by price',
      name: 'filterByPrice',
      desc: '',
      args: [],
    );
  }

  /// `Highest price`
  String get sortByHighestPrice {
    return Intl.message(
      'Highest price',
      name: 'sortByHighestPrice',
      desc: '',
      args: [],
    );
  }

  /// `Lowest price`
  String get sortByLowestPrice {
    return Intl.message(
      'Lowest price',
      name: 'sortByLowestPrice',
      desc: '',
      args: [],
    );
  }

  /// `Alphabetical`
  String get sortByAlphabetical {
    return Intl.message(
      'Alphabetical',
      name: 'sortByAlphabetical',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message('Products', name: 'products', desc: '', args: []);
  }

  /// `Alphabetical`
  String get alphabetical {
    return Intl.message(
      'Alphabetical',
      name: 'alphabetical',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `From`
  String get availableFrom {
    return Intl.message('From', name: 'availableFrom', desc: '', args: []);
  }

  /// `To`
  String get to {
    return Intl.message('To', name: 'to', desc: '', args: []);
  }

  /// `Enter starting price`
  String get enterStartPrice {
    return Intl.message(
      'Enter starting price',
      name: 'enterStartPrice',
      desc: '',
      args: [],
    );
  }

  /// `Enter ending price`
  String get enterEndPrice {
    return Intl.message(
      'Enter ending price',
      name: 'enterEndPrice',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid price range`
  String get enterValidPrice {
    return Intl.message(
      'Please enter a valid price range',
      name: 'enterValidPrice',
      desc: '',
      args: [],
    );
  }

  /// `Welcome !...`
  String get greeting {
    return Intl.message('Welcome !...', name: 'greeting', desc: '', args: []);
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Average`
  String get average {
    return Intl.message('Average', name: 'average', desc: '', args: []);
  }

  /// `Your Rating`
  String get yourRating {
    return Intl.message('Your Rating', name: 'yourRating', desc: '', args: []);
  }

  /// `Rate This Store`
  String get rateThisStore {
    return Intl.message(
      'Rate This Store',
      name: 'rateThisStore',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message('Cart', name: 'cart', desc: '', args: []);
  }

  /// `Added to cart successfully!`
  String get addedToCartSuccessfully {
    return Intl.message(
      'Added to cart successfully!',
      name: 'addedToCartSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Quantity increased`
  String get quantityIncreased {
    return Intl.message(
      'Quantity increased',
      name: 'quantityIncreased',
      desc: '',
      args: [],
    );
  }

  /// `Max quantity reached`
  String get maxQuantityReached {
    return Intl.message(
      'Max quantity reached',
      name: 'maxQuantityReached',
      desc: '',
      args: [],
    );
  }

  /// `Quantity decreased`
  String get quantityDecreased {
    return Intl.message(
      'Quantity decreased',
      name: 'quantityDecreased',
      desc: '',
      args: [],
    );
  }

  /// `Item removed`
  String get itemRemoved {
    return Intl.message(
      'Item removed',
      name: 'itemRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Cart cleared`
  String get cartCleared {
    return Intl.message(
      'Cart cleared',
      name: 'cartCleared',
      desc: '',
      args: [],
    );
  }

  /// `L.E`
  String get currency {
    return Intl.message('L.E', name: 'currency', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Your cart is empty`
  String get cartEmpty {
    return Intl.message(
      'Your cart is empty',
      name: 'cartEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Add items to your cart to get started`
  String get addItemsToCart {
    return Intl.message(
      'Add items to your cart to get started',
      name: 'addItemsToCart',
      desc: '',
      args: [],
    );
  }

  /// `Total Items`
  String get totalItems {
    return Intl.message('Total Items', name: 'totalItems', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Checkout`
  String get checkout {
    return Intl.message('Checkout', name: 'checkout', desc: '', args: []);
  }

  /// `Clear Cart`
  String get clearCart {
    return Intl.message('Clear Cart', name: 'clearCart', desc: '', args: []);
  }

  /// `Are you sure you want to clear your cart?`
  String get clearCartConfirmation {
    return Intl.message(
      'Are you sure you want to clear your cart?',
      name: 'clearCartConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Product not found!`
  String get productNotFound {
    return Intl.message(
      'Product not found!',
      name: 'productNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Available quantity of`
  String get availableQuantityFrom {
    return Intl.message(
      'Available quantity of',
      name: 'availableQuantityFrom',
      desc: '',
      args: [],
    );
  }

  /// `is`
  String get quantityIs {
    return Intl.message('is', name: 'quantityIs', desc: '', args: []);
  }

  /// `Search for a location`
  String get search_for_location {
    return Intl.message(
      'Search for a location',
      name: 'search_for_location',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get about_us {
    return Intl.message('About Us', name: 'about_us', desc: '', args: []);
  }

  /// `Choose Language`
  String get choose_language {
    return Intl.message(
      'Choose Language',
      name: 'choose_language',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `General`
  String get general {
    return Intl.message('General', name: 'general', desc: '', args: []);
  }

  /// `My Orders`
  String get myOrders {
    return Intl.message('My Orders', name: 'myOrders', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message('Help', name: 'help', desc: '', args: []);
  }

  /// `Contact Support`
  String get contact_support {
    return Intl.message(
      'Contact Support',
      name: 'contact_support',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected Error`
  String get unexpectedError {
    return Intl.message(
      'Unexpected Error',
      name: 'unexpectedError',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Dark Mode`
  String get dark_mode {
    return Intl.message('Dark Mode', name: 'dark_mode', desc: '', args: []);
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get requiredField {
    return Intl.message(
      'This field is required',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully ✅`
  String get passwordChanged {
    return Intl.message(
      'Password changed successfully ✅',
      name: 'passwordChanged',
      desc: '',
      args: [],
    );
  }

  /// `Password change failed ❌`
  String get passwordChangeFailed {
    return Intl.message(
      'Password change failed ❌',
      name: 'passwordChangeFailed',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred: {error}`
  String errorOccurred(Object error) {
    return Intl.message(
      'An error occurred: $error',
      name: 'errorOccurred',
      desc: '',
      args: [error],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Shipping`
  String get shipping {
    return Intl.message('Shipping', name: 'shipping', desc: '', args: []);
  }

  /// `User Details:`
  String get userDetails {
    return Intl.message(
      'User Details:',
      name: 'userDetails',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Phone Number`
  String get phone {
    return Intl.message('Phone Number', name: 'phone', desc: '', args: []);
  }

  /// `Delivery Address`
  String get deliveryAddress {
    return Intl.message(
      'Delivery Address',
      name: 'deliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Payment:`
  String get payment {
    return Intl.message('Payment:', name: 'payment', desc: '', args: []);
  }

  /// `Cash on Delivery`
  String get cashOnDelivery {
    return Intl.message(
      'Cash on Delivery',
      name: 'cashOnDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Pay Online`
  String get payOnline {
    return Intl.message('Pay Online', name: 'payOnline', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Please complete the required fields`
  String get pleaseFillData {
    return Intl.message(
      'Please complete the required fields',
      name: 'pleaseFillData',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your full name`
  String get pleaseEnterFullName {
    return Intl.message(
      'Please enter your full name',
      name: 'pleaseEnterFullName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get pleaseEnterPhone {
    return Intl.message(
      'Please enter your phone number',
      name: 'pleaseEnterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your delivery address`
  String get pleaseEnterAddress {
    return Intl.message(
      'Please enter your delivery address',
      name: 'pleaseEnterAddress',
      desc: '',
      args: [],
    );
  }

  /// `Loading location...`
  String get loading_location {
    return Intl.message(
      'Loading location...',
      name: 'loading_location',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch address`
  String get failed_to_fetch_address {
    return Intl.message(
      'Failed to fetch address',
      name: 'failed_to_fetch_address',
      desc: '',
      args: [],
    );
  }

  /// `Please wait for location to be determined`
  String get please_wait_for_location {
    return Intl.message(
      'Please wait for location to be determined',
      name: 'please_wait_for_location',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Location`
  String get confirm_location {
    return Intl.message(
      'Confirm Location',
      name: 'confirm_location',
      desc: '',
      args: [],
    );
  }

  /// `en`
  String get localeName {
    return Intl.message('en', name: 'localeName', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Phone Number`
  String get phone_number {
    return Intl.message(
      'Phone Number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message('Subtotal', name: 'subtotal', desc: '', args: []);
  }

  /// `Delivery`
  String get delivery {
    return Intl.message('Delivery', name: 'delivery', desc: '', args: []);
  }

  /// `Payment Method`
  String get payment_method {
    return Intl.message(
      'Payment Method',
      name: 'payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Order Summary:`
  String get order_summary {
    return Intl.message(
      'Order Summary:',
      name: 'order_summary',
      desc: '',
      args: [],
    );
  }

  /// `No Stores Found`
  String get no_stores_found {
    return Intl.message(
      'No Stores Found',
      name: 'no_stores_found',
      desc: '',
      args: [],
    );
  }

  /// `No Products Found`
  String get no_products_found {
    return Intl.message(
      'No Products Found',
      name: 'no_products_found',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Search Results`
  String get searchResults {
    return Intl.message(
      'Search Results',
      name: 'searchResults',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get order {
    return Intl.message('Order', name: 'order', desc: '', args: []);
  }

  /// `Items`
  String get items {
    return Intl.message('Items', name: 'items', desc: '', args: []);
  }

  /// `More items`
  String get moreItems {
    return Intl.message('More items', name: 'moreItems', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Confirmed`
  String get confirmed {
    return Intl.message('Confirmed', name: 'confirmed', desc: '', args: []);
  }

  /// `Shipped`
  String get shipped {
    return Intl.message('Shipped', name: 'shipped', desc: '', args: []);
  }

  /// `Delivered`
  String get delivered {
    return Intl.message('Delivered', name: 'delivered', desc: '', args: []);
  }

  /// `Canceled`
  String get canceled {
    return Intl.message('Canceled', name: 'canceled', desc: '', args: []);
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `No Orders Found`
  String get noOrders {
    return Intl.message(
      'No Orders Found',
      name: 'noOrders',
      desc: '',
      args: [],
    );
  }

  /// `No orders available`
  String get noOrdersSubtitle {
    return Intl.message(
      'No orders available',
      name: 'noOrdersSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Order Date`
  String get orderDate {
    return Intl.message('Order Date', name: 'orderDate', desc: '', args: []);
  }

  /// `Track Order`
  String get trackOrder {
    return Intl.message('Track Order', name: 'trackOrder', desc: '', args: []);
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message('Quantity', name: 'quantity', desc: '', args: []);
  }

  /// `Cancel Order`
  String get cancelOrder {
    return Intl.message(
      'Cancel Order',
      name: 'cancelOrder',
      desc: '',
      args: [],
    );
  }

  /// `The order is out for delivery, please contact support`
  String get orderOutForDelivery {
    return Intl.message(
      'The order is out for delivery, please contact support',
      name: 'orderOutForDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get review {
    return Intl.message('Reviews', name: 'review', desc: '', args: []);
  }

  /// `Overall Rating`
  String get overallRating {
    return Intl.message(
      'Overall Rating',
      name: 'overallRating',
      desc: '',
      args: [],
    );
  }

  /// `Based on {count} reviews`
  String basedOnReviews(Object count) {
    return Intl.message(
      'Based on $count reviews',
      name: 'basedOnReviews',
      desc: 'Text showing the number of reviews',
      args: [count],
    );
  }

  /// `Customer Reviews`
  String get customerReviews {
    return Intl.message(
      'Customer Reviews',
      name: 'customerReviews',
      desc: '',
      args: [],
    );
  }

  /// `No reviews yet`
  String get noReviews {
    return Intl.message(
      'No reviews yet',
      name: 'noReviews',
      desc: '',
      args: [],
    );
  }

  /// `Add a Review`
  String get addReview {
    return Intl.message('Add a Review', name: 'addReview', desc: '', args: []);
  }

  /// `Rate this product`
  String get rateProduct {
    return Intl.message(
      'Rate this product',
      name: 'rateProduct',
      desc: '',
      args: [],
    );
  }

  /// `Your comment`
  String get yourComment {
    return Intl.message(
      'Your comment',
      name: 'yourComment',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Review submitted successfully`
  String get reviewSubmitted {
    return Intl.message(
      'Review submitted successfully',
      name: 'reviewSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Error submitting review`
  String get errorSubmittingReview {
    return Intl.message(
      'Error submitting review',
      name: 'errorSubmittingReview',
      desc: '',
      args: [],
    );
  }

  /// `Add a Reply`
  String get addReply {
    return Intl.message('Add a Reply', name: 'addReply', desc: '', args: []);
  }

  /// `Your reply`
  String get yourReply {
    return Intl.message('Your reply', name: 'yourReply', desc: '', args: []);
  }

  /// `Store Reply`
  String get storeReply {
    return Intl.message('Store Reply', name: 'storeReply', desc: '', args: []);
  }

  /// `Reply submitted successfully`
  String get replySubmitted {
    return Intl.message(
      'Reply submitted successfully',
      name: 'replySubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Error submitting reply`
  String get errorSubmittingReply {
    return Intl.message(
      'Error submitting reply',
      name: 'errorSubmittingReply',
      desc: '',
      args: [],
    );
  }

  /// `Login Required`
  String get loginRequired {
    return Intl.message(
      'Login Required',
      name: 'loginRequired',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `WhatsApp Number`
  String get whatsapp_number {
    return Intl.message(
      'WhatsApp Number',
      name: 'whatsapp_number',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get date_of_birth {
    return Intl.message(
      'Date of Birth',
      name: 'date_of_birth',
      desc: '',
      args: [],
    );
  }

  /// `National ID`
  String get national_id {
    return Intl.message('National ID', name: 'national_id', desc: '', args: []);
  }

  /// `Please enter your National ID`
  String get please_enter_national_id {
    return Intl.message(
      'Please enter your National ID',
      name: 'please_enter_national_id',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your address`
  String get please_enter_address {
    return Intl.message(
      'Please enter your address',
      name: 'please_enter_address',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Please enter your date of birth`
  String get please_enter_date_of_birth {
    return Intl.message(
      'Please enter your date of birth',
      name: 'please_enter_date_of_birth',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your location`
  String get please_enter_location {
    return Intl.message(
      'Please enter your location',
      name: 'please_enter_location',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your WhatsApp number`
  String get please_enter_whatsapp_number {
    return Intl.message(
      'Please enter your WhatsApp number',
      name: 'please_enter_whatsapp_number',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get please_enter_your_phone_number {
    return Intl.message(
      'Please enter your phone number',
      name: 'please_enter_your_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `You must log in first.`
  String get mustLoginFirst {
    return Intl.message(
      'You must log in first.',
      name: 'mustLoginFirst',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get personal_information {
    return Intl.message(
      'Personal Information',
      name: 'personal_information',
      desc: '',
      args: [],
    );
  }

  /// `Contact Information`
  String get contact_information {
    return Intl.message(
      'Contact Information',
      name: 'contact_information',
      desc: '',
      args: [],
    );
  }

  /// `Address Information`
  String get address_information {
    return Intl.message(
      'Address Information',
      name: 'address_information',
      desc: '',
      args: [],
    );
  }

  /// `Account Information`
  String get account_information {
    return Intl.message(
      'Account Information',
      name: 'account_information',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Company Information`
  String get company_information {
    return Intl.message(
      'Company Information',
      name: 'company_information',
      desc: '',
      args: [],
    );
  }

  /// `Coupon`
  String get coupon {
    return Intl.message('Coupon', name: 'coupon', desc: '', args: []);
  }

  /// `Please enter the coupon`
  String get please_enter_coupon {
    return Intl.message(
      'Please enter the coupon',
      name: 'please_enter_coupon',
      desc: '',
      args: [],
    );
  }

  /// `Select Company`
  String get select_company {
    return Intl.message(
      'Select Company',
      name: 'select_company',
      desc: '',
      args: [],
    );
  }

  /// `Please select a company`
  String get please_select_company {
    return Intl.message(
      'Please select a company',
      name: 'please_select_company',
      desc: '',
      args: [],
    );
  }

  /// `No company found`
  String get no_company_found {
    return Intl.message(
      'No company found',
      name: 'no_company_found',
      desc: '',
      args: [],
    );
  }

  /// `Hotline`
  String get hotline {
    return Intl.message('Hotline', name: 'hotline', desc: '', args: []);
  }

  /// `Tiktok`
  String get tiktok {
    return Intl.message('Tiktok', name: 'tiktok', desc: '', args: []);
  }

  /// `Instagram`
  String get instagram {
    return Intl.message('Instagram', name: 'instagram', desc: '', args: []);
  }

  /// `Facebook`
  String get facebook {
    return Intl.message('Facebook', name: 'facebook', desc: '', args: []);
  }

  /// `Website`
  String get website {
    return Intl.message('Website', name: 'website', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `WhatsApp`
  String get whatsapp {
    return Intl.message('WhatsApp', name: 'whatsapp', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Please select gender`
  String get please_select_gender {
    return Intl.message(
      'Please select gender',
      name: 'please_select_gender',
      desc: '',
      args: [],
    );
  }

  /// `Cannot launch URL`
  String get cannotLaunchUrl {
    return Intl.message(
      'Cannot launch URL',
      name: 'cannotLaunchUrl',
      desc: '',
      args: [],
    );
  }

  /// `No categories found`
  String get no_categories_found {
    return Intl.message(
      'No categories found',
      name: 'no_categories_found',
      desc: '',
      args: [],
    );
  }

  /// `Flash Deals`
  String get flashDeals {
    return Intl.message('Flash Deals', name: 'flashDeals', desc: '', args: []);
  }

  /// `Offer ended`
  String get offerEnded {
    return Intl.message('Offer ended', name: 'offerEnded', desc: '', args: []);
  }

  /// `Time Left`
  String get timeLeft {
    return Intl.message('Time Left', name: 'timeLeft', desc: '', args: []);
  }

  /// `No available notifications`
  String get no_available_notifications {
    return Intl.message(
      'No available notifications',
      name: 'no_available_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Mark all as read`
  String get markAllAsRead {
    return Intl.message(
      'Mark all as read',
      name: 'markAllAsRead',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Error loading notifications`
  String get errorLoadingNotifications {
    return Intl.message(
      'Error loading notifications',
      name: 'errorLoadingNotifications',
      desc: '',
      args: [],
    );
  }

  /// `You will be notified here when new notifications are available.`
  String get noNotificationsSubtitle {
    return Intl.message(
      'You will be notified here when new notifications are available.',
      name: 'noNotificationsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Add Review`
  String get add_review_ar {
    return Intl.message(
      'Add Review',
      name: 'add_review_ar',
      desc: '',
      args: [],
    );
  }

  /// `Add Review`
  String get add_review_en {
    return Intl.message(
      'Add Review',
      name: 'add_review_en',
      desc: '',
      args: [],
    );
  }

  /// `Rating`
  String get rating {
    return Intl.message('Rating', name: 'rating', desc: '', args: []);
  }

  /// `Comment`
  String get comment {
    return Intl.message('Comment', name: 'comment', desc: '', args: []);
  }

  /// `Enter your comment`
  String get enter_comment {
    return Intl.message(
      'Enter your comment',
      name: 'enter_comment',
      desc: '',
      args: [],
    );
  }

  /// `Comment is required`
  String get comment_required {
    return Intl.message(
      'Comment is required',
      name: 'comment_required',
      desc: '',
      args: [],
    );
  }

  /// `Submit Review`
  String get submit_review {
    return Intl.message(
      'Submit Review',
      name: 'submit_review',
      desc: '',
      args: [],
    );
  }

  /// `Update Review`
  String get update_review {
    return Intl.message(
      'Update Review',
      name: 'update_review',
      desc: '',
      args: [],
    );
  }

  /// `Review submitted successfully`
  String get review_submitted {
    return Intl.message(
      'Review submitted successfully',
      name: 'review_submitted',
      desc: '',
      args: [],
    );
  }

  /// `Please select a rating`
  String get please_select_rating {
    return Intl.message(
      'Please select a rating',
      name: 'please_select_rating',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product {
    return Intl.message('Product', name: 'product', desc: '', args: []);
  }

  /// `Product Reviews`
  String get product_reviews_ar {
    return Intl.message(
      'Product Reviews',
      name: 'product_reviews_ar',
      desc: '',
      args: [],
    );
  }

  /// `Product Reviews`
  String get product_reviews_en {
    return Intl.message(
      'Product Reviews',
      name: 'product_reviews_en',
      desc: '',
      args: [],
    );
  }

  /// `No reviews yet`
  String get no_reviews {
    return Intl.message(
      'No reviews yet',
      name: 'no_reviews',
      desc: '',
      args: [],
    );
  }

  /// `Admin Reply`
  String get admin_reply {
    return Intl.message('Admin Reply', name: 'admin_reply', desc: '', args: []);
  }

  /// `Failed to add review`
  String get error_add_review {
    return Intl.message(
      'Failed to add review',
      name: 'error_add_review',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update review`
  String get error_update_review {
    return Intl.message(
      'Failed to update review',
      name: 'error_update_review',
      desc: '',
      args: [],
    );
  }

  /// `Read more`
  String get read_more {
    return Intl.message('Read more', name: 'read_more', desc: '', args: []);
  }

  /// `Read less`
  String get read_less {
    return Intl.message('Read less', name: 'read_less', desc: '', args: []);
  }

  /// `Show admin reply`
  String get show_admin_reply {
    return Intl.message(
      'Show admin reply',
      name: 'show_admin_reply',
      desc: '',
      args: [],
    );
  }

  /// `Hide admin reply`
  String get hide_admin_reply {
    return Intl.message(
      'Hide admin reply',
      name: 'hide_admin_reply',
      desc: '',
      args: [],
    );
  }

  /// `Invalid date format`
  String get invalid_date_format {
    return Intl.message(
      'Invalid date format',
      name: 'invalid_date_format',
      desc: '',
      args: [],
    );
  }

  /// `Change Personal Details`
  String get changePersonalDetails {
    return Intl.message(
      'Change Personal Details',
      name: 'changePersonalDetails',
      desc: '',
      args: [],
    );
  }

  /// `Error updating profile`
  String get error_updating_profile {
    return Intl.message(
      'Error updating profile',
      name: 'error_updating_profile',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully`
  String get profile_updated_successfully {
    return Intl.message(
      'Profile updated successfully',
      name: 'profile_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get save_changes {
    return Intl.message(
      'Save Changes',
      name: 'save_changes',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your name`
  String get please_enter_your_name {
    return Intl.message(
      'Please enter your name',
      name: 'please_enter_your_name',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Verify OTP`
  String get verify_otp {
    return Intl.message('Verify OTP', name: 'verify_otp', desc: '', args: []);
  }

  /// `Enter the OTP sent to {email}`
  String enter_otp_sent_to(Object email) {
    return Intl.message(
      'Enter the OTP sent to $email',
      name: 'enter_otp_sent_to',
      desc: '',
      args: [email],
    );
  }

  /// `OTP`
  String get otp {
    return Intl.message('OTP', name: 'otp', desc: '', args: []);
  }

  /// `Verify`
  String get verify {
    return Intl.message('Verify', name: 'verify', desc: '', args: []);
  }

  /// `OTP must be 6 digits`
  String get otp_invalid_length {
    return Intl.message(
      'OTP must be 6 digits',
      name: 'otp_invalid_length',
      desc: '',
      args: [],
    );
  }

  /// `Invalid OTP`
  String get otp_invalid {
    return Intl.message('Invalid OTP', name: 'otp_invalid', desc: '', args: []);
  }

  /// `OTP has expired`
  String get otp_expired {
    return Intl.message(
      'OTP has expired',
      name: 'otp_expired',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get sendOTP {
    return Intl.message('Send OTP', name: 'sendOTP', desc: '', args: []);
  }

  /// `OTP sent successfully`
  String get otp_sent {
    return Intl.message(
      'OTP sent successfully',
      name: 'otp_sent',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP`
  String get resend_otp {
    return Intl.message('Resend OTP', name: 'resend_otp', desc: '', args: []);
  }

  /// `Time remaining: {time}`
  String time_remaining(Object time) {
    return Intl.message(
      'Time remaining: $time',
      name: 'time_remaining',
      desc: '',
      args: [time],
    );
  }

  /// `Order Successful!`
  String get orderSuccessTitle {
    return Intl.message(
      'Order Successful!',
      name: 'orderSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for your order! Your order has been confirmed .`
  String get orderSuccessMessage {
    return Intl.message(
      'Thank you for your order! Your order has been confirmed .',
      name: 'orderSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Order Number: #{number}`
  String orderNumber(Object number) {
    return Intl.message(
      'Order Number: #$number',
      name: 'orderNumber',
      desc: '',
      args: [number],
    );
  }

  /// `Order Date: {date}`
  String orderDateNumber(Object date) {
    return Intl.message(
      'Order Date: $date',
      name: 'orderDateNumber',
      desc: '',
      args: [date],
    );
  }

  /// `Back to Home`
  String get backToHome {
    return Intl.message('Back to Home', name: 'backToHome', desc: '', args: []);
  }

  /// `Confirm Order`
  String get confirmOrder {
    return Intl.message(
      'Confirm Order',
      name: 'confirmOrder',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connection`
  String get noInternetConnection {
    return Intl.message(
      'No Internet Connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Please check your connection`
  String get pleaseCheckYourConnection {
    return Intl.message(
      'Please check your connection',
      name: 'pleaseCheckYourConnection',
      desc: '',
      args: [],
    );
  }

  /// `Job`
  String get job {
    return Intl.message('Job', name: 'job', desc: '', args: []);
  }

  /// `Please enter your job `
  String get pleaseEnterYourJob {
    return Intl.message(
      'Please enter your job ',
      name: 'pleaseEnterYourJob',
      desc: '',
      args: [],
    );
  }

  /// `Pay on site`
  String get payLocally {
    return Intl.message('Pay on site', name: 'payLocally', desc: '', args: []);
  }

  /// `Add to local cart`
  String get addToLocalCart {
    return Intl.message(
      'Add to local cart',
      name: 'addToLocalCart',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one product`
  String get please_select_products {
    return Intl.message(
      'Please select at least one product',
      name: 'please_select_products',
      desc: '',
      args: [],
    );
  }

  /// `on site`
  String get local {
    return Intl.message('on site', name: 'local', desc: '', args: []);
  }

  /// `Online`
  String get online {
    return Intl.message('Online', name: 'online', desc: '', args: []);
  }

  /// `Paid`
  String get paid {
    return Intl.message('Paid', name: 'paid', desc: '', args: []);
  }

  /// `An Egyptian company established in 2019 specializing in project management and development, marketing consultancy, digital marketing, and software development. The company aims to provide integrated solutions that help clients grow and achieve their goals efficiently and professionally.\n\nMyfe is the first fully integrated service application of its kind in Egypt and the Middle East. It aims to provide employees with all their needs in one place at competitive prices across various sectors, offering a high-consumption customer base and maximizing the financial value of employee salaries through the services provided by the app.`
  String get about_us_content {
    return Intl.message(
      'An Egyptian company established in 2019 specializing in project management and development, marketing consultancy, digital marketing, and software development. The company aims to provide integrated solutions that help clients grow and achieve their goals efficiently and professionally.\n\nMyfe is the first fully integrated service application of its kind in Egypt and the Middle East. It aims to provide employees with all their needs in one place at competitive prices across various sectors, offering a high-consumption customer base and maximizing the financial value of employee salaries through the services provided by the app.',
      name: 'about_us_content',
      desc: '',
      args: [],
    );
  }

  /// `This page is used to inform users of our policies regarding the collection, use, and disclosure of personal information if anyone decides to use our Service. By using our Service, you agree to the collection and use of information in accordance with this policy.\n\nWe collect information to provide and improve the service. We will not use or share your information with anyone except as described in this Privacy Policy.\n\nWe may require you to provide certain personal information, such as your name, phone number, date of birth, and location, to enhance your experience while using the app.\n\nThe app may use third-party services that may collect information used to identify you, such as Google Play Services.\n\nIn case of an error while using the app, we may collect data such as your IP address, device name, operating system, and the time and date of usage.\n\nThe app uses cookies to store information and improve the user experience. You can choose to refuse cookies, but some parts of the service may not function properly.\n\nWe may employ third-party companies to facilitate our service or analyze how it is used. These third parties have access to your personal information only to perform specific tasks on our behalf.\n\nWe strive to protect your information using secure methods, but no method of transmission or storage is 100% secure.\n\nThe app may contain links to external websites, and we are not responsible for their privacy policies.\n\nWe do not knowingly collect personal information from children under the age of 13. If we discover such information, we immediately delete it.\n\nWe may update our Privacy Policy from time to time. Any changes will be posted on this page.`
  String get privacy_policy_content {
    return Intl.message(
      'This page is used to inform users of our policies regarding the collection, use, and disclosure of personal information if anyone decides to use our Service. By using our Service, you agree to the collection and use of information in accordance with this policy.\n\nWe collect information to provide and improve the service. We will not use or share your information with anyone except as described in this Privacy Policy.\n\nWe may require you to provide certain personal information, such as your name, phone number, date of birth, and location, to enhance your experience while using the app.\n\nThe app may use third-party services that may collect information used to identify you, such as Google Play Services.\n\nIn case of an error while using the app, we may collect data such as your IP address, device name, operating system, and the time and date of usage.\n\nThe app uses cookies to store information and improve the user experience. You can choose to refuse cookies, but some parts of the service may not function properly.\n\nWe may employ third-party companies to facilitate our service or analyze how it is used. These third parties have access to your personal information only to perform specific tasks on our behalf.\n\nWe strive to protect your information using secure methods, but no method of transmission or storage is 100% secure.\n\nThe app may contain links to external websites, and we are not responsible for their privacy policies.\n\nWe do not knowingly collect personal information from children under the age of 13. If we discover such information, we immediately delete it.\n\nWe may update our Privacy Policy from time to time. Any changes will be posted on this page.',
      name: 'privacy_policy_content',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `New update available!`
  String get updateAvailable {
    return Intl.message(
      'New update available!',
      name: 'updateAvailable',
      desc: '',
      args: [],
    );
  }

  /// `New version:`
  String get newVersion {
    return Intl.message('New version:', name: 'newVersion', desc: '', args: []);
  }

  /// `Bug fixes and performance improvements for a smoother experience.`
  String get updateDescription {
    return Intl.message(
      'Bug fixes and performance improvements for a smoother experience.',
      name: 'updateDescription',
      desc: '',
      args: [],
    );
  }

  /// `Download update`
  String get downloadUpdate {
    return Intl.message(
      'Download update',
      name: 'downloadUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Later`
  String get later {
    return Intl.message('Later', name: 'later', desc: '', args: []);
  }

  /// `The app is under construction`
  String get maintenance {
    return Intl.message(
      'The app is under construction',
      name: 'maintenance',
      desc: '',
      args: [],
    );
  }

  /// `Please wait until the construction is over`
  String get pleaseWait {
    return Intl.message(
      'Please wait until the construction is over',
      name: 'pleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `Continue as Guest`
  String get continueAsGuest {
    return Intl.message(
      'Continue as Guest',
      name: 'continueAsGuest',
      desc: '',
      args: [],
    );
  }

  /// `Don’t want to sign in?`
  String get dontWantToSignIn {
    return Intl.message(
      'Don’t want to sign in?',
      name: 'dontWantToSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get resturantMenu {
    return Intl.message('Menu', name: 'resturantMenu', desc: '', args: []);
  }

  /// `Please log in to continue`
  String get loginToContinue {
    return Intl.message(
      'Please log in to continue',
      name: 'loginToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Coming Soon`
  String get comingSoon {
    return Intl.message('Coming Soon', name: 'comingSoon', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
