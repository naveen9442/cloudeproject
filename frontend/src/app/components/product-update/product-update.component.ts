// frontend/src/app/components/product-update/product-update.component.ts
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ProductService, Product } from '../../services/product.service';

@Component({
  selector: 'app-product-update',
  templateUrl: './product-update.component.html',
  styleUrls: ['./product-update.component.css'],
})
export class ProductUpdateComponent implements OnInit {
  product: Product = {
    name: '',
    description: '',
    price: 0,
    category: 'Electronics',
    stock: 0,
  };

  loading = false;
  error: string | null = null;
  categories = ['Electronics', 'Clothing', 'Books', 'Food', 'Other'];
  productId: string | null = null;

  constructor(
    private productService: ProductService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.productId = this.route.snapshot.paramMap.get('id');
    if (this.productId) {
      this.loadProduct(this.productId);
    }
  }

  loadProduct(id: string): void {
    this.loading = true;
    this.productService.getProductById(id).subscribe({
      next: (response) => {
        this.product = response.data as Product;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Failed to load product';
        console.error(err);
        this.loading = false;
      },
    });
  }

  onSubmit(): void {
    if (!this.productId) return;

    this.loading = true;
    this.error = null;

    if (!this.product.name || !this.product.description || this.product.price <= 0) {
      this.error = 'Please fill in all required fields with valid values';
      this.loading = false;
      return;
    }

    this.productService.updateProduct(this.productId, this.product).subscribe({
      next: (response) => {
        this.router.navigate(['/products', this.productId]);
      },
      error: (err) => {
        this.error = err.error?.message || 'Failed to update product';
        console.error(err);
        this.loading = false;
      },
    });
  }

  onCancel(): void {
    this.router.navigate(['/products', this.productId]);
  }
}
