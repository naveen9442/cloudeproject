// frontend/src/app/components/product-list/product-list.component.ts
import { Component, OnInit } from '@angular/core';
import { ProductService, Product } from '../../services/product.service';

@Component({
  selector: 'app-product-list',
  templateUrl: './product-list.component.html',
  styleUrls: ['./product-list.component.css'],
})
export class ProductListComponent implements OnInit {
  products: Product[] = [];
  loading = false;
  error: string | null = null;
  currentPage = 1;
  totalPages = 1;
  limit = 10;
  categories = ['Electronics', 'Clothing', 'Books', 'Food', 'Other'];
  selectedCategory = '';
  searchQuery = '';

  constructor(private productService: ProductService) {}

  ngOnInit(): void {
    this.loadProducts();
  }

  loadProducts(): void {
    this.loading = true;
    this.error = null;

    this.productService
      .getProducts(this.currentPage, this.limit, this.selectedCategory, this.searchQuery)
      .subscribe({
        next: (response) => {
          this.products = response.data as Product[];
          this.totalPages = response.pages || 1;
          this.loading = false;
        },
        error: (err) => {
          this.error = 'Failed to load products';
          console.error(err);
          this.loading = false;
        },
      });
  }

  onCategoryChange(): void {
    this.currentPage = 1;
    this.loadProducts();
  }

  onSearch(): void {
    this.currentPage = 1;
    this.loadProducts();
  }

  previousPage(): void {
    if (this.currentPage > 1) {
      this.currentPage--;
      this.loadProducts();
    }
  }

  nextPage(): void {
    if (this.currentPage < this.totalPages) {
      this.currentPage++;
      this.loadProducts();
    }
  }

  deleteProduct(id: string | undefined): void {
    if (!id) return;

    if (confirm('Are you sure you want to delete this product?')) {
      this.productService.deleteProduct(id).subscribe({
        next: () => {
          this.loadProducts();
        },
        error: (err) => {
          this.error = 'Failed to delete product';
          console.error(err);
        },
      });
    }
  }

  resetFilters(): void {
    this.selectedCategory = '';
    this.searchQuery = '';
    this.currentPage = 1;
    this.loadProducts();
  }
}
