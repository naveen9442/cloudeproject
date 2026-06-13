// frontend/src/app/components/product-create/product-create.component.ts
import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { ProductService, Product } from '../../services/product.service';

@Component({
  selector: 'app-product-create',
  templateUrl: './product-create.component.html',
  styleUrls: ['./product-create.component.css'],
})
export class ProductCreateComponent {
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

  constructor(private productService: ProductService, private router: Router) {}

  onSubmit(): void {
    this.loading = true;
    this.error = null;

    // Validation
    if (!this.product.name || !this.product.description || this.product.price <= 0) {
      this.error = 'Please fill in all required fields with valid values';
      this.loading = false;
      return;
    }

    this.productService.createProduct(this.product).subscribe({
      next: (response) => {
        this.router.navigate(['/products']);
      },
      error: (err) => {
        this.error = err.error?.message || 'Failed to create product';
        console.error(err);
        this.loading = false;
      },
    });
  }

  onCancel(): void {
    this.router.navigate(['/products']);
  }
}
