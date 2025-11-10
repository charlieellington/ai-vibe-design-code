# Admin Features - Simplified (With Auth)

## Original Request

**From @baby-build-plan.md Phase 3 (PRESERVED VERBATIM):**

## Phase 3: Admin Features (Simplified - No Auth)

### Single Admin Page at `/upload`

#### Step 3.1: Create Upload Page Route
```bash
mkdir -p app/upload
touch app/upload/page.tsx
```

Create `/app/upload/page.tsx`:
```typescript
// Single page with all admin functionality (no auth required)
// Security through obscurity - only share link with parents
// MVP approach: simple tables, basic functionality

export default function UploadPage() {
  // Main sections:
  // 1. Add Item Form (top, main focus)
  // 2. Current Items Table (edit/delete inline)
  // 3. Contributions List (view who bought what)
  // 4. Messages List (from gift givers)
}
```

#### Step 3.2: Add Item Form Component
Create `/components/admin/add-item-form.tsx`:
```typescript
// Simple form at top of page:
- Image upload (using existing utilities from Phase 1.6)
- Title input
- Description textarea
- Price input
- Category dropdown (essentials/experiences/big-items/donation)
- Priority number input
- Submit button

// MVP: Basic form validation, success/error messages
// No fancy UI, just functional
```

#### Step 3.3: Items Management Table
Create `/components/admin/items-table.tsx`:
```typescript
// Simple table showing all items:
- Thumbnail image
- Title, price, category
- Available status (checkbox to toggle)
- Edit button (inline editing or simple modal)
- Delete button (with confirmation)
- Priority value (editable number field)

// MVP approach:
- No drag-and-drop reordering
- Basic HTML table with Tailwind styling
- Inline editing where possible
- Simple confirmation dialogs
```

#### Step 3.4: Contributions & Messages Lists
Create `/components/admin/contributions-list.tsx`:
```typescript
// Simple list/table of contributions:
- Item name
- Contributor name/email
- Amount
- Gift code
- Date
- Message (if any)

// Just display data, no complex interactions
```

Create `/components/admin/messages-list.tsx`:
```typescript
// Simple list of thank you messages:
- From name/email
- Message text
- Date

// Read-only display
```

#### Step 3.5: Server Actions for CRUD Operations
Add to `/app/upload/page.tsx` or create `/app/upload/actions.ts`:
```typescript
'use server'

// Add item action
export async function addItem(formData: FormData) {
  // Upload image if provided
  // Insert item into database
  // Revalidate page
}

// Update item action
export async function updateItem(id: string, data: any) {
  // Update item in database
  // Revalidate page
}

// Delete item action
export async function deleteItem(id: string) {
  // Delete image from storage if exists
  // Delete item from database
  // Revalidate page
}

// Toggle availability
export async function toggleAvailability(id: string, available: boolean) {
  // Quick update of availability status
  // Revalidate page
}
```

**Integration Points:**
- ✓ No authentication needed (security through obscurity)
- ✓ Single page with all functionality
- ✓ Form as main focus at top
- ✓ Simple tables for data display
- ✓ Basic CRUD operations
- ✓ MVP approach throughout

**ADDITIONAL CONTEXT FROM BUILD PLAN:**

### Current Status (from baby-build-plan.md)
> **📅 PROJECT START: November 6, 2024**
>
> ### ✅ Completed Phases
> - **Phase 1: Foundation & Database Setup** - Complete (Nov 6, 2024)
> - **Phase 1.5: Streamline Existing Boilerplate** - Complete (Nov 6, 2024)
> - **Phase 1.6: Image Storage Foundation** - Complete (Nov 6, 2024)
>
> ### 🚀 READY FOR
> **Phase 2**: Public-Facing Features Implementation
>
> ### 📦 Available Resources
> - Next.js app with TypeScript and Tailwind CSS configured
> - Supabase authentication system (admin-only)
> - Supabase client utilities configured
> - Environment variables set up (.env.local)
> - UI components from shadcn/ui installed (button, card, input, label, badge, checkbox, dropdown-menu)
> - Auth flow pages functional at `/auth/login` (admin access)
> - Protected routes structure at `/app/protected/*`
> - **Database tables**: items, contributions, messages (see Phase 1 for details)
> - **Storage bucket**: item-images with compression utilities (see Phase 1.6 for details)
> - **TypeScript types**: `types/supabase.ts`
> - **Utilities**: `lib/items.ts`, `lib/favorites.ts`, `lib/storage.ts`
> - **Image compression**: browser-image-compression library installed

### Build Philosophy (from baby-build-plan.md)
- **Mobile-first development**: Test on mobile viewport at each step
- **Progressive enhancement**: Core functionality first, polish later
- **No authentication for gift givers**: Simple, frictionless experience
- **Admin-only protected routes**: Reuse existing auth for admin features
- **localStorage for personalization**: Hearts and favorites without accounts
- **Component reuse**: Leverage existing UI components from shadcn/ui

**CRITICAL NOTE - UPDATED BASED ON REVIEW:** This phase now uses the SAME approach as existing protected routes:
- **Existing `/app/protected/*` routes**: Use full Supabase authentication with auth checks
- **New `/protected/upload` route**: USES authentication (more secure than original plan)
- **Rationale**: Security is paramount for admin features, leverages existing auth infrastructure

## Design Context

No Figma design provided. This is a functional admin interface with MVP approach:

### UI Requirements
- **Clean, simple layout** - no fancy design needed
- **Mobile-responsive** - admin might add items from phone
- **Clear visual hierarchy** - form at top, data tables below
- **Functional over beautiful** - MVP focus on working features

### Interaction Requirements
- **Image upload with preview** - show uploaded image before submission
- **Inline editing where possible** - reduce clicks for quick updates
- **Confirmation dialogs** - prevent accidental deletions
- **Success/error feedback** - toast notifications or inline messages
- **Form validation** - basic client-side validation for required fields

## Codebase Context

### Existing Auth Structure (NOW USED in this implementation)

**Protected routes exist at `/app/protected/*`:**
- File: `/app/protected/page.tsx` 
- Uses Supabase authentication: `const { data, error } = await supabase.auth.getClaims()`
- Redirects to `/auth/login` if not authenticated
- Currently shows placeholder cards for future admin features

**Why we ARE using this (UPDATED):**
- Review identified critical RLS policy conflict with no-auth approach
- Security is more important than simplicity for admin features
- Leverages existing auth infrastructure (less work overall)
- Parents can use existing `/auth/login` to access admin area
- RLS policies work correctly with authenticated users

### Available Utilities

**Image Storage** (`lib/storage.ts`):
```typescript
// EXISTING FUNCTIONS - REUSE THESE:
export async function compressImage(file: File): Promise<Blob>
  // Compresses to max 1MB, 1200px dimension
  // Uses browser-image-compression library

export async function uploadImage(file: File, itemId: string): Promise<string | null>
  // Compresses and uploads to 'item-images' bucket
  // Returns public URL or null on error

export async function deleteImage(imageUrl: string): Promise<boolean>
  // Extracts filename from URL and removes from storage
  // Returns success/failure boolean

export function getOptimizedImageUrl(imageUrl: string, options?: {...}): string
  // Generates URLs with transformation parameters
  // For responsive images
```

**Items Management** (`lib/items.ts`):
```typescript
// EXISTING FUNCTIONS - REUSE THESE:
export async function getItems(category?: string)
  // Fetches items with optional category filter
  // Orders by priority ascending
  // Only returns available items by default

export async function getItem(itemId: string)
  // Gets single item by ID

export async function markItemPurchased(itemId: string, contribution: NewContribution)
  // Records contribution and marks item unavailable if full amount

export async function getItemContributions(itemId: string)
  // Gets all contributions for an item

export async function getItemTotalContributed(itemId: string)
  // Calculates total contributed amount
```

### Database Schema (from Phase 1)

**Items table:**
```sql
CREATE TABLE items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  image_url TEXT,
  category TEXT CHECK (category IN ('essentials', 'experiences', 'big-items', 'donation')),
  priority INTEGER DEFAULT 999,
  available BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Contributions table:**
```sql
CREATE TABLE contributions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  item_id UUID REFERENCES items(id) ON DELETE CASCADE,
  contributor_name TEXT,
  contributor_email TEXT,
  amount DECIMAL(10, 2),
  is_full_amount BOOLEAN DEFAULT false,
  gift_code TEXT UNIQUE,
  message TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Messages table:**
```sql
CREATE TABLE messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  contributor_name TEXT,
  contributor_email TEXT,
  message TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### TypeScript Types (`types/supabase.ts`)

```typescript
export interface Item {
  id: string;
  title: string;
  description: string | null;
  price: number;
  image_url: string | null;
  category: 'essentials' | 'experiences' | 'big-items' | 'donation';
  priority: number;
  available: boolean;
  created_at: string;
  updated_at: string;
}

export interface Contribution {
  id: string;
  item_id: string;
  contributor_name: string | null;
  contributor_email: string | null;
  amount: number;
  is_full_amount: boolean;
  gift_code: string;
  message: string | null;
  created_at: string;
}

export interface Message {
  id: string;
  contributor_name: string | null;
  contributor_email: string | null;
  message: string;
  created_at: string;
}
```

### Available UI Components (shadcn/ui)

**Already installed:**
- `components/ui/button.tsx` - Primary buttons, variants (default, destructive, outline, secondary, ghost, link)
- `components/ui/card.tsx` - Card containers
- `components/ui/input.tsx` - Text inputs
- `components/ui/label.tsx` - Form labels
- `components/ui/badge.tsx` - Status badges
- `components/ui/checkbox.tsx` - Checkboxes
- `components/ui/dropdown-menu.tsx` - Dropdown menus

**Need to install for Phase 3:**
```bash
npx shadcn@latest add dialog      # For delete confirmations
npx shadcn@latest add textarea    # For description input
npx shadcn@latest add table       # For items/contributions/messages display
npx shadcn@latest add select      # For category dropdown
# Note: toast removed based on review decision (using inline messages)
```

### File Structure Context

**New files to create:**
```
app/
  protected/
    upload/
      page.tsx              # Main admin page (NEW)
      actions.ts            # Server actions for CRUD (NEW)

components/
  admin/                    # New admin directory
    add-item-form.tsx       # Add item form component (NEW)
    items-table.tsx         # Items management table (NEW)
    contributions-list.tsx   # Contributions display (NEW)
    messages-list.tsx       # Messages display (NEW)
```

**Existing files to reference:**
- `lib/storage.ts` - Use uploadImage, deleteImage, compressImage
- `lib/items.ts` - Reference patterns for database queries
- `types/supabase.ts` - Use Item, Contribution, Message types
- `components/ui/*` - Use existing shadcn components

## Prototype Scope

**IMPORTANT:** This is NOT a prototype - this is a real production feature with MVP approach.

### MVP Approach (UPDATED)
- **Authenticated access** - uses existing Supabase auth (decision from review)
- **Simple UI** - functional tables and forms, not heavily styled
- **Basic interactions** - no drag-and-drop, no complex animations
- **Direct database operations** - use Server Actions for simplicity
- **Mobile-responsive** - must work on phone for on-the-go admin
- **Error handling** - basic validation and inline error messages

### What's Included (MVP)
- ✅ Add new items with image upload
- ✅ Delete items with confirmation
- ✅ Toggle item availability (checkbox)
- ✅ View all contributions with details
- ✅ View all messages from gift givers
- ✅ Image compression before upload
- ✅ Form validation (including file type/size)
- ✅ Success/error feedback (inline messages)
- ✅ Authentication required for access
- ✅ Tables with horizontal scroll on mobile

### What's Deferred (Future Enhancement)
- ❌ Edit functionality for items (use Supabase dashboard for now)
- ❌ Drag-and-drop priority reordering
- ❌ Image cropping/editing tools
- ❌ Bulk operations (multi-select, batch delete)
- ❌ Advanced filtering and search
- ❌ Export data to CSV/Excel
- ❌ Email notifications
- ❌ Analytics dashboard
- ❌ Toast notifications (using inline messages for MVP)

## Plan

### Step 1: Install Required UI Components
**File:** Terminal command
**Time estimate:** 2 minutes
**Action:**
```bash
npx shadcn@latest add dialog textarea table select
```

**Why:** Need these components for admin interface:
- `dialog` - Delete confirmation dialogs
- `textarea` - Multi-line description input
- `table` - Display items, contributions, messages
- `select` - Category dropdown (with hidden input for form submission)

### Step 2: Create Server Actions File
**File:** `app/protected/upload/actions.ts` (NEW)
**Dependencies:** 
- `lib/supabase/server` (existing)
- `lib/storage` (existing - uploadImage, deleteImage)
- `types/supabase` (existing - Item type)

**Implementation:**
```typescript
'use server'

import { createClient } from '@/lib/supabase/server';
import { uploadImage, deleteImage } from '@/lib/storage';
import { revalidatePath } from 'next/cache';
import type { Item } from '@/types/supabase';

/**
 * Add new item to database with optional image upload
 * Handles image compression and storage via uploadImage utility
 */
export async function addItem(formData: FormData) {
  const supabase = await createClient();

  // Extract form data
  const title = formData.get('title') as string;
  const description = formData.get('description') as string;
  const price = parseFloat(formData.get('price') as string);
  const category = formData.get('category') as string;
  const priority = parseInt(formData.get('priority') as string) || 999;
  const imageFile = formData.get('image') as File | null;

  // Validation
  if (!title || !price || !category) {
    return { success: false, error: 'Missing required fields' };
  }

  try {
    // First insert item to get ID for image upload
    const { data: newItem, error: insertError } = await supabase
      .from('items')
      .insert({
        title,
        description,
        price,
        category,
        priority,
        available: true,
      })
      .select()
      .single();

    if (insertError) throw insertError;

    // Upload image if provided
    let imageUrl = null;
    if (imageFile && imageFile.size > 0) {
      imageUrl = await uploadImage(imageFile, newItem.id);
      
      // Update item with image URL
      if (imageUrl) {
        await supabase
          .from('items')
          .update({ image_url: imageUrl })
          .eq('id', newItem.id);
      }
    }

    revalidatePath('/protected/upload');
    return { success: true, data: newItem };
  } catch (error) {
    console.error('Add item error:', error);
    return { success: false, error: 'Failed to add item' };
  }
}

// Note: Edit functionality deferred to future enhancement (MVP decision)
// Users can edit items directly in Supabase dashboard if needed

/**
 * Delete item and its image from storage
 */
export async function deleteItem(itemId: string, imageUrl: string | null) {
  const supabase = await createClient();

  try {
    // Delete image from storage if exists
    if (imageUrl) {
      await deleteImage(imageUrl);
    }

    // Delete item (contributions cascade delete automatically)
    const { error: deleteError } = await supabase
      .from('items')
      .delete()
      .eq('id', itemId);

    if (deleteError) throw deleteError;

    revalidatePath('/protected/upload');
    return { success: true };
  } catch (error) {
    console.error('Delete item error:', error);
    return { success: false, error: 'Failed to delete item' };
  }
}

/**
 * Quick toggle of item availability status
 */
export async function toggleAvailability(itemId: string, available: boolean) {
  const supabase = await createClient();

  try {
    const { error } = await supabase
      .from('items')
      .update({ 
        available,
        updated_at: new Date().toISOString(),
      })
      .eq('id', itemId);

    if (error) throw error;

    revalidatePath('/protected/upload');
    return { success: true };
  } catch (error) {
    console.error('Toggle availability error:', error);
    return { success: false, error: 'Failed to toggle availability' };
  }
}

/**
 * Fetch all items for admin view (including unavailable)
 */
export async function getAllItems() {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('items')
    .select('*')
    .order('priority', { ascending: true });

  if (error) {
    console.error('Fetch items error:', error);
    return { data: [], error: error.message };
  }

  return { data, error: null };
}

/**
 * Fetch all contributions for admin view
 */
export async function getAllContributions() {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('contributions')
    .select(`
      *,
      items (
        title
      )
    `)
    .order('created_at', { ascending: false });

  if (error) {
    console.error('Fetch contributions error:', error);
    return { data: [], error: error.message };
  }

  return { data, error: null };
}

/**
 * Fetch all messages for admin view
 */
export async function getAllMessages() {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('messages')
    .select('*')
    .order('created_at', { ascending: false });

  if (error) {
    console.error('Fetch messages error:', error);
    return { data: [], error: error.message };
  }

  return { data, error: null };
}
```

**Testing:** Server actions are tested via form submissions in the UI

### Step 3: Create Add Item Form Component
**File:** `components/admin/add-item-form.tsx` (NEW)
**Dependencies:**
- `components/ui/button` (existing)
- `components/ui/input` (existing)
- `components/ui/label` (existing)
- `components/ui/textarea` (new - install in Step 1)
- `components/ui/select` (new - install in Step 1)
- `app/protected/upload/actions` (created in Step 2)

**Implementation:**
```typescript
'use client';

import { useState, useRef } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { addItem } from '@/app/protected/upload/actions';
import Image from 'next/image';

export function AddItemForm() {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [imagePreview, setImagePreview] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const formRef = useRef<HTMLFormElement>(null);

  const handleImageChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      // Basic validation
      const maxSize = 10 * 1024 * 1024; // 10MB limit before compression
      const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
      
      if (!allowedTypes.includes(file.type)) {
        setError('Please select a valid image file (JPEG, PNG, GIF, or WebP)');
        e.target.value = '';
        return;
      }
      
      if (file.size > maxSize) {
        setError('Image file is too large. Please select an image under 10MB');
        e.target.value = '';
        return;
      }
      
      // Create preview URL
      const reader = new FileReader();
      reader.onloadend = () => {
        setImagePreview(reader.result as string);
        setError(null); // Clear any previous errors
      };
      reader.readAsDataURL(file);
    }
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setIsSubmitting(true);
    setError(null);
    setSuccess(null);

    const formData = new FormData(e.currentTarget);
    const result = await addItem(formData);

    if (result.success) {
      setSuccess('Item added successfully!');
      formRef.current?.reset();
      setImagePreview(null);
    } else {
      setError(result.error || 'Failed to add item');
    }

    setIsSubmitting(false);
  };

  return (
    <div className="rounded-lg border bg-card p-6">
      <h2 className="text-2xl font-bold mb-6">Add New Item</h2>
      
      <form ref={formRef} onSubmit={handleSubmit} className="space-y-4">
        {/* Image Upload */}
        <div className="space-y-2">
          <Label htmlFor="image">Item Image</Label>
          <Input
            id="image"
            name="image"
            type="file"
            accept="image/*"
            onChange={handleImageChange}
          />
          {imagePreview && (
            <div className="relative h-48 w-full mt-2 rounded-lg overflow-hidden border">
              <Image
                src={imagePreview}
                alt="Preview"
                fill
                className="object-cover"
              />
            </div>
          )}
        </div>

        {/* Title */}
        <div className="space-y-2">
          <Label htmlFor="title">Title *</Label>
          <Input
            id="title"
            name="title"
            placeholder="Baby Monitor"
            required
          />
        </div>

        {/* Description */}
        <div className="space-y-2">
          <Label htmlFor="description">Description</Label>
          <Textarea
            id="description"
            name="description"
            placeholder="Video baby monitor with night vision..."
            rows={3}
          />
        </div>

        {/* Price and Category Row */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {/* Price */}
          <div className="space-y-2">
            <Label htmlFor="price">Price *</Label>
            <Input
              id="price"
              name="price"
              type="number"
              step="0.01"
              min="0"
              placeholder="99.99"
              required
            />
          </div>

          {/* Category */}
          <div className="space-y-2">
            <Label htmlFor="category">Category *</Label>
            <Select onValueChange={(value) => {
              // Update hidden input when selection changes
              const input = document.getElementById('category-hidden') as HTMLInputElement;
              if (input) input.value = value;
            }}>
              <SelectTrigger>
                <SelectValue placeholder="Select category" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="essentials">Essentials</SelectItem>
                <SelectItem value="experiences">Experiences</SelectItem>
                <SelectItem value="big-items">Big Items</SelectItem>
                <SelectItem value="donation">Donation</SelectItem>
              </SelectContent>
            </Select>
            {/* Hidden input for form submission */}
            <input type="hidden" name="category" id="category-hidden" required />
          </div>

        {/* Priority */}
        <div className="space-y-2">
          <Label htmlFor="priority">Priority (lower number = higher priority)</Label>
          <Input
            id="priority"
            name="priority"
            type="number"
            min="1"
            defaultValue="999"
            placeholder="999"
          />
        </div>

        {/* Success/Error Messages */}
        {success && (
          <div className="rounded-lg bg-green-50 dark:bg-green-900/20 p-4 text-sm text-green-900 dark:text-green-200">
            {success}
          </div>
        )}
        {error && (
          <div className="rounded-lg bg-red-50 dark:bg-red-900/20 p-4 text-sm text-red-900 dark:text-red-200">
            {error}
          </div>
        )}

        {/* Submit Button */}
        <Button
          type="submit"
          disabled={isSubmitting}
          className="w-full"
        >
          {isSubmitting ? 'Adding Item...' : 'Add Item'}
        </Button>
      </form>
    </div>
  );
}
```

**Why client component:** Form interactions, image preview, loading states

### Step 4: Create Items Management Table Component
**File:** `components/admin/items-table.tsx` (NEW)
**Dependencies:**
- `components/ui/table` (new - install in Step 1)
- `components/ui/button` (existing)
- `components/ui/checkbox` (existing)
- `components/ui/badge` (existing)
- `components/ui/dialog` (new - install in Step 1)
- `app/protected/upload/actions` (created in Step 2)

**Implementation:**
```typescript
'use client';

import { useState } from 'react';
import Image from 'next/image';
import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import { Badge } from '@/components/ui/badge';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { toggleAvailability, deleteItem } from '@/app/protected/upload/actions';
import type { Item } from '@/types/supabase';

interface ItemsTableProps {
  items: Item[];
}

export function ItemsTable({ items }: ItemsTableProps) {
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [itemToDelete, setItemToDelete] = useState<Item | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);

  const handleToggleAvailability = async (item: Item) => {
    await toggleAvailability(item.id, !item.available);
  };

  const handleDeleteClick = (item: Item) => {
    setItemToDelete(item);
    setDeleteDialogOpen(true);
  };

  const handleDeleteConfirm = async () => {
    if (!itemToDelete) return;
    
    setIsDeleting(true);
    await deleteItem(itemToDelete.id, itemToDelete.image_url);
    setIsDeleting(false);
    setDeleteDialogOpen(false);
    setItemToDelete(null);
  };

  const getCategoryLabel = (category: string) => {
    const labels = {
      'essentials': 'Essentials',
      'experiences': 'Experiences',
      'big-items': 'Big Items',
      'donation': 'Donation',
    };
    return labels[category as keyof typeof labels] || category;
  };

  return (
    <>
      <div className="rounded-lg border bg-card">
        <div className="p-6 border-b">
          <h2 className="text-2xl font-bold">Manage Items</h2>
          <p className="text-sm text-muted-foreground mt-1">
            {items.length} item{items.length !== 1 ? 's' : ''} total
          </p>
        </div>
        
        {/* Table wrapped in horizontal scroll container for mobile */}
        <div className="overflow-x-auto">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead className="w-20">Image</TableHead>
                <TableHead>Title</TableHead>
                <TableHead>Category</TableHead>
                <TableHead className="text-right">Price</TableHead>
                <TableHead className="text-center">Priority</TableHead>
                <TableHead className="text-center">Available</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {items.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={7} className="text-center text-muted-foreground py-8">
                    No items yet. Add your first item above!
                  </TableCell>
                </TableRow>
              ) : (
                items.map((item) => (
                  <TableRow key={item.id}>
                    <TableCell>
                      {item.image_url ? (
                        <div className="relative h-12 w-12 rounded overflow-hidden">
                          <Image
                            src={item.image_url}
                            alt={item.title}
                            fill
                            className="object-cover"
                          />
                        </div>
                      ) : (
                        <div className="h-12 w-12 rounded bg-muted flex items-center justify-center text-xs text-muted-foreground">
                          No image
                        </div>
                      )}
                    </TableCell>
                    <TableCell>
                      <div>
                        <div className="font-medium">{item.title}</div>
                        {item.description && (
                          <div className="text-sm text-muted-foreground truncate max-w-xs">
                            {item.description}
                          </div>
                        )}
                      </div>
                    </TableCell>
                    <TableCell>
                      <Badge variant="secondary">
                        {getCategoryLabel(item.category)}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-right font-medium">
                      ${item.price.toFixed(2)}
                    </TableCell>
                    <TableCell className="text-center">
                      {item.priority}
                    </TableCell>
                    <TableCell className="text-center">
                      <Checkbox
                        checked={item.available}
                        onCheckedChange={() => handleToggleAvailability(item)}
                      />
                    </TableCell>
                    <TableCell className="text-right">
                      <div className="flex gap-2 justify-end">
                        <Button
                          variant="destructive"
                          size="sm"
                          onClick={() => handleDeleteClick(item)}
                        >
                          Delete
                        </Button>
                      </div>
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </div>
      </div>

      {/* Delete Confirmation Dialog */}
      <Dialog open={deleteDialogOpen} onOpenChange={setDeleteDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Delete Item</DialogTitle>
            <DialogDescription>
              Are you sure you want to delete "{itemToDelete?.title}"? This action cannot be undone.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button
              variant="outline"
              onClick={() => setDeleteDialogOpen(false)}
              disabled={isDeleting}
            >
              Cancel
            </Button>
            <Button
              variant="destructive"
              onClick={handleDeleteConfirm}
              disabled={isDeleting}
            >
              {isDeleting ? 'Deleting...' : 'Delete'}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
```

**Why client component:** Interactive table with checkboxes, delete dialogs, async actions

**Note:** Edit functionality deferred to future enhancement (MVP focuses on delete and availability toggle)

### Step 5: Create Contributions List Component
**File:** `components/admin/contributions-list.tsx` (NEW)
**Dependencies:**
- `components/ui/table` (new - install in Step 1)
- `components/ui/badge` (existing)

**Implementation:**
```typescript
'use client';

import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';

interface Contribution {
  id: string;
  item_id: string;
  contributor_name: string | null;
  contributor_email: string | null;
  amount: number;
  is_full_amount: boolean;
  gift_code: string;
  message: string | null;
  created_at: string;
  items: {
    title: string;
  } | null;
}

interface ContributionsListProps {
  contributions: Contribution[];
}

export function ContributionsList({ contributions }: ContributionsListProps) {
  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  return (
    <div className="rounded-lg border bg-card">
      <div className="p-6 border-b">
        <h2 className="text-2xl font-bold">Contributions</h2>
        <p className="text-sm text-muted-foreground mt-1">
          {contributions.length} contribution{contributions.length !== 1 ? 's' : ''} received
        </p>
      </div>
      
      <div className="overflow-x-auto">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Item</TableHead>
              <TableHead>Contributor</TableHead>
              <TableHead>Email</TableHead>
              <TableHead className="text-right">Amount</TableHead>
              <TableHead>Type</TableHead>
              <TableHead>Gift Code</TableHead>
              <TableHead>Message</TableHead>
              <TableHead>Date</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {contributions.length === 0 ? (
              <TableRow>
                <TableCell colSpan={8} className="text-center text-muted-foreground py-8">
                  No contributions yet. They'll appear here once gift givers make purchases.
                </TableCell>
              </TableRow>
            ) : (
              contributions.map((contribution) => (
                <TableRow key={contribution.id}>
                  <TableCell className="font-medium">
                    {contribution.items?.title || 'Unknown Item'}
                  </TableCell>
                  <TableCell>
                    {contribution.contributor_name || 'Anonymous'}
                  </TableCell>
                  <TableCell className="text-muted-foreground">
                    {contribution.contributor_email || '—'}
                  </TableCell>
                  <TableCell className="text-right font-medium">
                    ${contribution.amount.toFixed(2)}
                  </TableCell>
                  <TableCell>
                    <Badge variant={contribution.is_full_amount ? 'default' : 'secondary'}>
                      {contribution.is_full_amount ? 'Full' : 'Partial'}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    <code className="text-xs bg-muted px-2 py-1 rounded">
                      {contribution.gift_code}
                    </code>
                  </TableCell>
                  <TableCell className="max-w-xs truncate">
                    {contribution.message || '—'}
                  </TableCell>
                  <TableCell className="text-sm text-muted-foreground">
                    {formatDate(contribution.created_at)}
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>
    </div>
  );
}
```

**Why client component:** Date formatting logic

### Step 6: Create Messages List Component
**File:** `components/admin/messages-list.tsx` (NEW)
**Dependencies:**
- `components/ui/card` (existing)

**Implementation:**
```typescript
'use client';

import { Card, CardContent } from '@/components/ui/card';

interface Message {
  id: string;
  contributor_name: string | null;
  contributor_email: string | null;
  message: string;
  created_at: string;
}

interface MessagesListProps {
  messages: Message[];
}

export function MessagesList({ messages }: MessagesListProps) {
  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  return (
    <div className="rounded-lg border bg-card">
      <div className="p-6 border-b">
        <h2 className="text-2xl font-bold">Messages from Contributors</h2>
        <p className="text-sm text-muted-foreground mt-1">
          {messages.length} message{messages.length !== 1 ? 's' : ''} received
        </p>
      </div>
      
      <div className="p-6">
        {messages.length === 0 ? (
          <div className="text-center text-muted-foreground py-8">
            No messages yet. Contributors can leave messages on the thank you page.
          </div>
        ) : (
          <div className="space-y-4">
            {messages.map((message) => (
              <Card key={message.id}>
                <CardContent className="p-4">
                  <div className="flex justify-between items-start mb-2">
                    <div>
                      <div className="font-medium">
                        {message.contributor_name || 'Anonymous'}
                      </div>
                      {message.contributor_email && (
                        <div className="text-sm text-muted-foreground">
                          {message.contributor_email}
                        </div>
                      )}
                    </div>
                    <div className="text-xs text-muted-foreground">
                      {formatDate(message.created_at)}
                    </div>
                  </div>
                  <p className="text-sm">{message.message}</p>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
```

**Why client component:** Date formatting logic

### Step 7: Create Main Upload Page
**File:** `app/protected/upload/page.tsx` (NEW)
**Dependencies:**
- All components created in Steps 3-6
- `app/protected/upload/actions` (created in Step 2)
- `lib/supabase/server` (for auth check)

**Implementation:**
```typescript
import { redirect } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { AddItemForm } from '@/components/admin/add-item-form';
import { ItemsTable } from '@/components/admin/items-table';
import { ContributionsList } from '@/components/admin/contributions-list';
import { MessagesList } from '@/components/admin/messages-list';
import { getAllItems, getAllContributions, getAllMessages } from './actions';

export default async function UploadPage() {
  // Check authentication
  const supabase = await createClient();
  const { data, error } = await supabase.auth.getClaims();
  if (error || !data?.claims) {
    redirect('/auth/login');
  }

  // Fetch all data server-side
  const { data: items } = await getAllItems();
  const { data: contributions } = await getAllContributions();
  const { data: messages } = await getAllMessages();

  return (
    <div className="container mx-auto px-4 py-8 max-w-7xl">
      {/* Page Header */}
      <div className="mb-8">
        <h1 className="text-4xl font-bold mb-2">Baby Gift Registry Admin</h1>
        <p className="text-muted-foreground">
          Manage your gift list, view contributions, and read messages
        </p>
      </div>

      {/* Main Content - Stack vertically with spacing */}
      <div className="space-y-8">
        {/* 1. Add Item Form - Primary focus at top */}
        <AddItemForm />

        {/* 2. Items Management Table */}
        <ItemsTable items={items || []} />

        {/* 3. Contributions List */}
        <ContributionsList contributions={contributions || []} />

        {/* 4. Messages List */}
        <MessagesList messages={messages || []} />
      </div>
    </div>
  );
}
```

**Why server component:** 
- Performs authentication check server-side
- Fetches data server-side for fast initial load  
- Children components handle client interactivity
- Secure redirect to login if not authenticated

### Step 8: Testing Checklist

**Functional Testing:**
- [ ] Navigate to `http://localhost:3000/protected/upload` without auth - redirects to login
- [ ] Log in via `/auth/login` - successful authentication
- [ ] Navigate to `http://localhost:3000/protected/upload` with auth - page loads correctly
- [ ] Add new item with all fields - saves to database
- [ ] Add item with image - image compresses and uploads to storage
- [ ] Add item without image - saves successfully with null image_url
- [ ] Toggle item availability checkbox - updates immediately
- [ ] Delete item - shows confirmation dialog, removes from database and storage
- [ ] View contributions list - displays all contributions with item titles
- [ ] View messages list - displays all messages in card format
- [ ] Form validation - required fields prevent submission
- [ ] Image preview - shows preview before upload

**Mobile Testing:**
- [ ] Form is usable on mobile (viewport ~375px width)
- [ ] Tables scroll horizontally on mobile
- [ ] Image upload works on mobile device
- [ ] Touch interactions work smoothly
- [ ] Text is readable without zooming

**Edge Cases:**
- [ ] Upload very large image - compression works (reduces to ~1MB)
- [ ] Upload invalid file type - handled gracefully
- [ ] Delete item with contributions - contributions cascade delete
- [ ] Empty states display correctly (no items, no contributions, no messages)
- [ ] Long text in description - truncates properly in table
- [ ] Special characters in item title - saves and displays correctly

**Security Considerations:**
- [ ] Authentication required (updated from original plan)
- [ ] RLS policies in Supabase protect admin operations
- [ ] Only authenticated users can INSERT/UPDATE/DELETE items
- [ ] Image uploads go to public bucket with 5MB limit
- [ ] URL `/protected/upload` is protected by auth middleware

**Performance:**
- [ ] Page loads quickly with all data
- [ ] Image compression doesn't block UI
- [ ] Form submission shows loading state
- [ ] Large number of items (20+) renders without lag

## Stage
Ready for Manual Testing

## Questions for Clarification

### ✅ ALL QUESTIONS RESOLVED

**User Decisions:**
1. **RLS Policy Conflict**: Option C - Use authentication (most secure, leverages existing infrastructure)
2. **Select Component**: Option B - Hidden input with Select (maintains UI consistency)
3. **Edit Functionality**: Option A - No edit in MVP (use Supabase dashboard if needed)
4. **Feedback Pattern**: Option A - Inline messages only (no toast needed)
5. **Table Mobile**: Option A - Horizontal scroll container (simplest approach)
6. **Image Validation**: Option B + A - Basic validation AND compression handling

**Review Notes**:
- **Requirements Coverage**: ✅ All Phase 3 requirements addressed
- **Technical Accuracy**: ✅ RLS policy conflict resolved by using auth
- **Component Selection**: ✅ Select component fixed with hidden input
- **Mobile Responsiveness**: ✅ Table scroll behavior specified
- **Error Handling**: ✅ File validation added for better UX
- **CONTRIBUTING.md Compliance**: ✅ Follows all core principles
- **File Size**: ✅ All files under 250 lines
- **Simplicity**: ✅ MVP approach maintained throughout

**Plan Updates Applied**:
- Changed route from `/upload` to `/protected/upload` 
- Added authentication check in page component
- Added hidden input for Select component
- Removed updateItem function (edit deferred)
- Removed toast from dependencies
- Added file validation to image handler
- Updated all file paths and imports
- Updated testing checklist for auth flow

## Priority
High - This is the core admin functionality needed to manage the gift registry

## Created
2024-11-06

## Files

**New Files to Create:**
- `app/protected/upload/page.tsx` - Main admin page (Server Component with auth)
- `app/protected/upload/actions.ts` - Server actions for CRUD operations
- `components/admin/add-item-form.tsx` - Add item form (Client Component)
- `components/admin/items-table.tsx` - Items management table (Client Component)
- `components/admin/contributions-list.tsx` - Contributions display (Client Component)
- `components/admin/messages-list.tsx` - Messages display (Client Component)

**Existing Files to Reference (DO NOT MODIFY):**
- `lib/storage.ts` - Image upload utilities
- `lib/items.ts` - Database query patterns
- `types/supabase.ts` - TypeScript type definitions
- `components/ui/*` - Existing shadcn components

**Existing Files to Keep Unchanged:**
- `app/protected/page.tsx` - Existing authenticated admin route (not used in Phase 3)
- `app/auth/*` - Authentication pages (not used in Phase 3)

## Technical Discovery

### MCP Research Results

#### Component Availability Verification
**MCP Query**: `mcp_shadcn-ui-server_list-components`
**Result**: ✅ All required components confirmed available in shadcn/ui

**Required Components Status:**
- ✅ **dialog** - Available (Delete confirmation dialogs)
- ✅ **textarea** - Available (Multi-line description input)
- ✅ **table** - Available (Items/contributions/messages display)
- ✅ **select** - Available (Category dropdown)

**Installation Commands Verified:**
```bash
npx shadcn@latest add dialog textarea table select
```

#### Existing Component Patterns Analysis

**Form Pattern Verification** (from `components/login-form.tsx`):
- ✅ Client components with `"use client"` directive
- ✅ useState for error/loading states pattern established
- ✅ Form submission with error handling pattern verified
- ✅ Import pattern: `import { Component } from '@/components/ui/component'`

**Example Pattern:**
```typescript
const [error, setError] = useState<string | null>(null);
const [isLoading, setIsLoading] = useState(false);

const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault();
  setIsLoading(true);
  setError(null);
  // ... action
  setIsLoading(false);
};
```

#### Storage Utilities Verification

**File**: `lib/storage.ts`
**Functions Confirmed**:
- ✅ `compressImage(file: File): Promise<Blob>` - Compresses to max 1MB, 1200px dimension
- ✅ `uploadImage(file: File, itemId: string): Promise<string | null>` - Uploads to 'item-images' bucket
- ✅ `deleteImage(imageUrl: string): Promise<boolean>` - Removes from storage
- ✅ `getOptimizedImageUrl(imageUrl: string, options?): string` - Generates URLs with transformations

**Dependencies**: 
- ✅ `browser-image-compression` (v2.0.2) - Already installed

#### TypeScript Types Verification

**File**: `types/supabase.ts`
**Types Confirmed**:
- ✅ `Item` interface (id, title, description, price, image_url, category, priority, available, timestamps)
- ✅ `Contribution` interface (with items relation for joins)
- ✅ `Message` interface
- ✅ Category type: `'essentials' | 'experiences' | 'big-items' | 'donation'`

**All field types match database schema exactly** ✓

#### Protected Route Structure Verification

**Layout**: `app/protected/layout.tsx`
- ✅ Protected layout with navigation exists
- ✅ Admin navigation with "Back to Gift List" link
- ✅ AuthButton and ThemeSwitcher in header
- ✅ Container structure ready for new pages

**Authentication Pattern**: `app/protected/page.tsx`
```typescript
const supabase = await createClient();
const { data, error } = await supabase.auth.getClaims();
if (error || !data?.claims) {
  redirect('/auth/login');
}
```
- ✅ Server-side auth check pattern verified
- ✅ Redirect to login if not authenticated
- ✅ Pattern ready for reuse in `/protected/upload/page.tsx`

#### Next.js Image Configuration Verification

**File**: `next.config.ts`
- ✅ Supabase storage remote patterns configured: `*.supabase.co/storage/v1/object/public/**`
- ✅ Modern image formats enabled: AVIF, WebP
- ✅ Cache TTL: 31 days
- ✅ Mobile-first device sizes configured

**Compatibility**: Next.js Image component will work correctly with Supabase storage URLs ✓

#### Middleware Verification

**File**: `middleware.ts`
- ✅ Session update middleware active
- ✅ Matcher includes all routes (including `/protected/upload`)
- ✅ Auth will be enforced automatically

### Implementation Feasibility Assessment

#### ✅ No Blocking Issues Identified

**Component Dependencies**:
- All shadcn components available and tested
- Import paths follow established patterns
- No version conflicts with existing dependencies

**Code Patterns**:
- Form handling patterns established in codebase
- Auth checking pattern ready to reuse
- Storage utilities fully implemented and tested
- TypeScript types complete and accurate

**Infrastructure**:
- Protected route structure exists
- Layout provides navigation framework
- Middleware enforces authentication
- Image handling fully configured

#### Required Adjustments from Review

**1. Select Component with Hidden Input** (Review Decision #2):
```typescript
<Select onValueChange={(value) => {
  const input = document.getElementById('category-hidden') as HTMLInputElement;
  if (input) input.value = value;
}}>
  {/* ... options ... */}
</Select>
<input type="hidden" name="category" id="category-hidden" required />
```
✅ **Pattern Verified**: Compatible with existing React patterns in codebase

**2. File Validation** (Review Decision #6):
```typescript
const maxSize = 10 * 1024 * 1024; // 10MB
const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
```
✅ **Pattern Verified**: Standard File API validation, works client-side

**3. Table Horizontal Scroll** (Review Decision #5):
```typescript
<div className="overflow-x-auto">
  <Table>...</Table>
</div>
```
✅ **Pattern Verified**: Standard Tailwind responsive pattern

#### Resource Availability

**Existing Utilities Ready to Use**:
- ✅ `createClient()` from `@/lib/supabase/server`
- ✅ `createClient()` from `@/lib/supabase/client`
- ✅ All storage utilities from `@/lib/storage`
- ✅ `revalidatePath()` from Next.js
- ✅ `redirect()` from Next.js

**Component Library**:
- ✅ 7 shadcn components already installed (button, card, input, label, badge, checkbox, dropdown-menu)
- ✅ 4 new components needed (dialog, textarea, table, select)
- ✅ No conflicts with existing components

### Component Interaction Validation

#### Form Submission Flow
**Pattern**: FormData with Server Actions
```typescript
Client Form → FormData → Server Action → Database/Storage → revalidatePath → UI Update
```
✅ **Verified**: Pattern used in existing auth forms

#### Image Upload Flow
**Pattern**: File Input → Validation → Compression → Upload → Database Update
```typescript
File Selection → Client Validation → Form Submit → Server Action → 
  compressImage() → uploadImage() → Database Update → revalidatePath
```
✅ **Verified**: All utilities exist and work together

#### Auth Protection Flow
**Pattern**: Server Component → Auth Check → Redirect or Render
```typescript
Page Load → createClient() → getClaims() → 
  If No Auth: redirect('/auth/login')
  If Auth: Render Content
```
✅ **Verified**: Pattern established in `/protected/page.tsx`

### Installation Requirements

#### New Shadcn Components (Step 1)
```bash
npx shadcn@latest add dialog textarea table select
```
**Estimated Installation**:
- Time: ~2 minutes
- Bundle Impact: ~15KB total
- Dependencies: @radix-ui components (auto-installed)

#### No Additional npm Packages Required
All runtime dependencies already installed:
- ✅ React 19.0.0
- ✅ Next.js (latest)
- ✅ browser-image-compression 2.0.2
- ✅ lucide-react 0.511.0

### Directory Structure Verification

**New Directory Creation Required**:
```bash
mkdir -p app/protected/upload
mkdir -p components/admin
```

**File Locations Verified**:
- ✅ `app/protected/` directory exists
- ✅ `components/` directory exists
- ❌ `app/protected/upload/` needs creation
- ❌ `components/admin/` needs creation

### Mobile Responsiveness Validation

**Tailwind Classes for Mobile**:
- ✅ `container mx-auto px-4` - Responsive container
- ✅ `overflow-x-auto` - Horizontal scroll for tables
- ✅ `grid grid-cols-1 md:grid-cols-2` - Responsive grid
- ✅ All patterns already used in existing components

**Viewport Testing Required**:
- [ ] Test at 375px (mobile)
- [ ] Test at 768px (tablet)
- [ ] Test at 1024px+ (desktop)

### Security Validation

**RLS Policies Verified** (from `supabase/migrations/20241106000000_initial_schema.sql`):
```sql
CREATE POLICY "Items insertable by authenticated only" ON items
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Items updatable by authenticated only" ON items
  FOR UPDATE TO authenticated USING (true);

CREATE POLICY "Items deletable by authenticated only" ON items
  FOR DELETE TO authenticated USING (true);
```
✅ **Confirmed**: Authenticated users can INSERT/UPDATE/DELETE items
✅ **Auth requirement aligns with implementation plan**

### Discovery Summary

- ✅ **All Components Available**: Yes - dialog, textarea, table, select all confirmed
- ✅ **Import Paths Verified**: All follow `@/components/ui/[component]` pattern
- ✅ **Dependencies Ready**: All utilities, types, and dependencies in place
- ✅ **Auth Structure Complete**: Protected route pattern ready to extend
- ✅ **Storage System Verified**: Image upload utilities fully functional
- ✅ **Technical Blockers**: None identified
- ✅ **Ready for Implementation**: Yes - all requirements validated

**Implementation Confidence**: HIGH
- Established patterns in codebase
- All dependencies verified
- No architectural changes needed
- Clear file structure
- Security properly configured

**Special Notes**:
1. The plan update from `/upload` to `/protected/upload` is architecturally sound and leverages existing infrastructure
2. Select component with hidden input pattern is a clean solution for FormData compatibility
3. All review decisions (no edit, inline messages, horizontal scroll) are technically feasible
4. Image validation + compression provides good UX and security balance

**Next Stage**: Ready to Execute - Agent 4 can proceed with implementation


## Implementation Notes

### Files Created (2025-11-06)

**Shadcn UI Components Installed:**
- ✅ `components/ui/dialog.tsx` - Delete confirmation dialogs
- ✅ `components/ui/textarea.tsx` - Multi-line description input
- ✅ `components/ui/table.tsx` - Items/contributions/messages tables
- ✅ `components/ui/select.tsx` - Category dropdown
- ⚠️ Note: 1 file skipped during installation (already existed)

**Server Actions:**
- ✅ `app/protected/upload/actions.ts` (180 lines)
  - `addItem()` - Insert item with optional image upload
  - `deleteItem()` - Delete item and associated image from storage
  - `toggleAvailability()` - Quick availability status toggle
  - `getAllItems()` - Fetch all items (including unavailable for admin view)
  - `getAllContributions()` - Fetch contributions with item title joins
  - `getAllMessages()` - Fetch all contributor messages
  - All functions include error handling and revalidatePath

**Client Components:**
- ✅ `components/admin/add-item-form.tsx` (210 lines)
  - Image upload with preview
  - Client-side validation (file type, size)
  - Form reset on success
  - Inline success/error messages
  - Select component with hidden input pattern
  - Form state management (loading, error, success)

- ✅ `components/admin/items-table.tsx` (175 lines)
  - Image thumbnails with "No image" fallback
  - Toggle availability via checkbox
  - Delete with confirmation dialog
  - Category badges
  - Price display in euros (€)
  - Priority display
  - Horizontal scroll for mobile responsiveness
  - Empty state message

- ✅ `components/admin/contributions-list.tsx` (110 lines)
  - Full/Partial contribution badges
  - Gift code display
  - Item title via join
  - Date formatting
  - Horizontal scroll for mobile
  - Empty state message

- ✅ `components/admin/messages-list.tsx` (75 lines)
  - Card-based layout
  - Contributor info display
  - Date formatting
  - Empty state message

**Main Page:**
- ✅ `app/protected/upload/page.tsx` (50 lines)
  - Server component with auth check
  - Server-side data fetching
  - Redirects to login if unauthenticated
  - Vertical stacking layout with proper spacing
  - Responsive container with max-width

### Implementation Decisions

**Currency Display:**
- Used € (euro) symbol for all prices to match existing landing page implementation
- Consistent with "Landing Page with Gift Grid" completed task

**Authentication:**
- Followed existing `/protected/page.tsx` pattern exactly
- Server-side auth check with `getClaims()`
- Automatic redirect to `/auth/login` if not authenticated
- RLS policies ensure database security

**Form Pattern:**
- Select component uses hidden input for FormData compatibility (per review decision)
- Image preview with FileReader before upload
- Client-side file validation before server submission
- Form reset on successful submission

**Mobile Responsiveness:**
- Tables wrapped in `overflow-x-auto` for horizontal scroll
- Responsive grid (1 col mobile, 2 cols desktop) for form inputs
- Container with proper padding for all screen sizes

**MVP Scope Maintained:**
- No edit functionality (use Supabase dashboard if needed)
- Basic inline messages instead of toast notifications
- Simple table display without drag-and-drop reordering
- Functional design over heavily styled interface

### Build Verification Results

**TypeScript Compilation:**
- ✅ `npx tsc --noEmit` - Passed with no errors

**Next.js Build:**
- ✅ Compiled successfully in 2.6s
- ✅ Route `/protected/upload` registered as dynamic server-rendered (ƒ)
- ✅ All static pages generated successfully (15/15)
- ✅ No warnings or errors during build

### Code Quality Notes

**File Size Compliance:**
- All files under 250 lines (CONTRIBUTING.md requirement)
- Largest file: add-item-form.tsx at 210 lines

**Pattern Consistency:**
- Followed existing codebase patterns for forms and authentication
- Used established import paths (@/components/ui/*, @/lib/*)
- Consistent error handling across all server actions
- Date formatting function reused across components

**Security:**
- Server-side auth check on page load
- RLS policies protect all database operations
- Image validation (type, size) before upload
- No sensitive data exposed in client components

## Manual Test Instructions

### Prerequisites
1. **Start development server**: `npm run dev`
2. **Ensure Supabase is configured**: Check `.env.local` has valid credentials
3. **Have test images ready**: Prepare 2-3 images (various formats: JPG, PNG, WebP)

### Test 1: Authentication Protection
**URL**: `http://localhost:3000/protected/upload`

**Steps:**
1. Navigate to URL without being logged in
2. Verify redirect to `/auth/login`
3. Log in with admin credentials
4. Verify redirect back to upload page
5. Verify page loads with all 4 sections visible

**Expected Results:**
- ✅ Unauthenticated users redirected to login
- ✅ After login, page loads successfully
- ✅ Page header shows "Baby Gift Registry Admin"
- ✅ Four sections visible: Add Item Form, Manage Items, Contributions, Messages

### Test 2: Add Item with Image
**Location**: Add Item Form (top of page)

**Steps:**
1. Select an image file (JPG, ~2-3MB)
2. Verify image preview appears immediately
3. Fill in Title: "Test Baby Monitor"
4. Fill in Description: "Video monitor with night vision"
5. Fill in Price: 149.99
6. Select Category: "Essentials"
7. Leave Priority at default (999)
8. Click "Add Item"
9. Wait for submission (button shows "Adding Item...")
10. Verify success message appears
11. Verify form resets
12. Scroll to "Manage Items" table
13. Verify new item appears in table

**Expected Results:**
- ✅ Image preview shows before submission
- ✅ Success message: "Item added successfully!"
- ✅ Form clears after success
- ✅ New item appears in table with thumbnail
- ✅ Price shows as €149.99
- ✅ Category shows "Essentials" badge
- ✅ Priority shows 999
- ✅ Available checkbox is checked

### Test 3: Add Item without Image
**Location**: Add Item Form

**Steps:**
1. Do NOT select an image
2. Fill in Title: "Donation Contribution"
3. Leave Description empty
4. Fill in Price: 50.00
5. Select Category: "Donation"
6. Set Priority: 1
7. Click "Add Item"
8. Verify success
9. Check table for new item

**Expected Results:**
- ✅ Item saves successfully without image
- ✅ Table shows "No image" placeholder for item
- ✅ Price shows as €50.00
- ✅ Category shows "Donation" badge
- ✅ Priority shows 1 (higher priority than previous item)

### Test 4: Image Validation
**Location**: Add Item Form

**Steps:**
1. Try to upload a non-image file (e.g., .txt, .pdf)
2. Verify error message appears
3. Try to upload very large image (>10MB if available)
4. Verify error message

**Expected Results:**
- ✅ Invalid file type shows error: "Please select a valid image file (JPEG, PNG, GIF, or WebP)"
- ✅ Large file shows error: "Image file is too large. Please select an image under 10MB"
- ✅ File input clears after validation error

### Test 5: Toggle Item Availability
**Location**: Manage Items table

**Steps:**
1. Find any item in the table
2. Click the "Available" checkbox to uncheck it
3. Page should refresh/update
4. Verify checkbox now shows unchecked
5. Click checkbox again to re-check
6. Verify checkbox shows checked

**Expected Results:**
- ✅ Checkbox toggles immediately
- ✅ State persists after page refresh
- ✅ No error messages appear

### Test 6: Delete Item
**Location**: Manage Items table

**Steps:**
1. Find the "Test Baby Monitor" item
2. Click "Delete" button
3. Verify confirmation dialog appears
4. Read dialog: "Are you sure you want to delete "Test Baby Monitor"?"
5. Click "Cancel"
6. Verify dialog closes, item still exists
7. Click "Delete" again
8. Click "Delete" in dialog (red button)
9. Wait for deletion (button shows "Deleting...")
10. Verify item disappears from table

**Expected Results:**
- ✅ Confirmation dialog appears with item title
- ✅ Cancel keeps item in table
- ✅ Delete removes item from table
- ✅ Image is deleted from Supabase storage
- ✅ No error messages appear

### Test 7: Mobile Responsiveness
**Browser**: Chrome DevTools

**Steps:**
1. Open DevTools (F12)
2. Toggle device toolbar (Ctrl+Shift+M / Cmd+Shift+M)
3. Select "iPhone SE" or similar (375px width)
4. Scroll through entire page
5. Test form inputs (tap, type, select)
6. Scroll tables horizontally
7. Try "Manage Items" table horizontal scroll
8. Try "Contributions" table horizontal scroll
9. Test delete confirmation dialog
10. Switch to tablet size (768px)
11. Verify form shows 2-column layout for Price/Category

**Expected Results:**
- ✅ Form inputs are easily tappable (large touch targets)
- ✅ Text is readable without zooming
- ✅ Tables scroll horizontally on mobile
- ✅ Buttons are accessible and properly sized
- ✅ Dialog appears centered and readable
- ✅ Form switches to 2-column layout on tablet/desktop
- ✅ No horizontal page scroll (only table scroll)

### Test 8: Empty States
**Location**: Fresh database or delete all items

**Steps:**
1. Delete all items from table (or use fresh database)
2. Verify "Manage Items" shows empty message
3. Verify "Contributions" shows empty message
4. Verify "Messages" shows empty message

**Expected Results:**
- ✅ Manage Items: "No items yet. Add your first item above!"
- ✅ Contributions: "No contributions yet. They'll appear here once gift givers make purchases."
- ✅ Messages: "No messages yet. Contributors can leave messages on the thank you page."

### Test 9: Form Validation
**Location**: Add Item Form

**Steps:**
1. Leave all fields empty
2. Click "Add Item"
3. Verify browser validation prevents submission
4. Fill only Title
5. Click "Add Item"
6. Verify validation requires Price
7. Fill Price
8. Click "Add Item" without selecting Category
9. Verify validation requires Category

**Expected Results:**
- ✅ Required fields show browser validation messages
- ✅ Cannot submit form without Title, Price, and Category
- ✅ Description and Image are optional
- ✅ Priority has default value of 999

### Test 10: Large Data Set Performance
**Location**: Multiple items in table

**Steps:**
1. Add 5-10 items quickly (use simple data)
2. Verify table renders smoothly
3. Scroll through table
4. Toggle availability on multiple items
5. Check page load time

**Expected Results:**
- ✅ Table renders all items without lag
- ✅ Scrolling is smooth
- ✅ Checkbox toggles respond quickly
- ✅ Page loads in under 2 seconds

### Test 11: Navigation and Layout
**Location**: Protected pages

**Steps:**
1. Verify protected layout navigation appears
2. Click "Back to Gift List" (should be in layout)
3. Verify navigation to main page works
4. Return to `/protected/upload`
5. Verify AuthButton shows logged-in state
6. Test ThemeSwitcher if available

**Expected Results:**
- ✅ Protected layout provides navigation
- ✅ Can navigate between protected pages
- ✅ Auth state persists across navigation
- ✅ Theme switcher works (if present)

### Success Criteria

**✅ Move to Complete if:**
- All authentication checks work correctly
- Items can be added with and without images
- Image validation prevents invalid files
- Items can be deleted with confirmation
- Availability toggle works instantly
- Mobile view is fully functional
- Tables scroll horizontally on small screens
- Empty states display appropriately
- No console errors appear during testing
- Build compiles successfully

**⚠️ Move to Needs Work if:**
- Authentication bypass is possible
- Image upload fails or doesn't compress
- Form validation missing or broken
- Delete doesn't remove image from storage
- Mobile layout is unusable
- Console errors appear
- Build fails or has warnings
- Data doesn't refresh after mutations

### Known Limitations (MVP Scope)

These are intentionally deferred to future enhancements:
- ❌ No edit functionality (use Supabase dashboard for now)
- ❌ No drag-and-drop priority reordering
- ❌ No image cropping or editing tools
- ❌ No bulk operations or multi-select
- ❌ No search or advanced filtering
- ❌ No data export (CSV/Excel)
- ❌ No toast notifications (using inline messages)
- ❌ No email notifications for contributions

