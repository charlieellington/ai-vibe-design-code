# Local Development Setup Guide

## Quick Answer: Yes, you need 2 environment variables locally!

Based on your Vercel screenshot and the codebase analysis, here's what you need:

## ✅ What's Already Done

- ✅ **Supabase Project Created** - Vercel has automatically provisioned a Supabase project
- ✅ **Database Provisioned** - All POSTGRES_* variables show it's set up
- ✅ **Environment Variables Set on Vercel** - Your production/preview deployments will work

## 🔧 What You Need for Local Development

### Step 1: Create `.env.local` file

In your project root, create a file called `.env.local` with:

```bash
# Copy these 2 values from your Vercel Environment Variables:
NEXT_PUBLIC_SUPABASE_URL=<your-supabase-url>
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=<your-anon-key>
```

**Where to get the values:**

From your Vercel screenshot:
- `NEXT_PUBLIC_SUPABASE_URL` → Copy the value (should be like: `https://xxxxx.supabase.co`)
- `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` → Use the value from `NEXT_PUBLIC_SUPABASE_ANON_KEY` or `SUPABASE_ANON_KEY`

**Note:** The code uses `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` but Vercel shows `NEXT_PUBLIC_SUPABASE_ANON_KEY` - they're the same thing and interchangeable!

### Step 2: Install Dependencies

```bash
npm install
# or if you prefer pnpm/yarn:
# pnpm install
# yarn install
```

### Step 3: Run Locally

```bash
npm run dev
```

Your app will be running at [http://localhost:3000](http://localhost:3000)

---

## 🤔 What About All Those Other Environment Variables?

**You DON'T need them locally!** Here's why:

### ❌ NOT Needed for Basic Development:
- `POSTGRES_*` variables - These are for direct database connections, but the Supabase client handles everything
- `SUPABASE_SERVICE_ROLE_KEY` - Only needed for admin operations (server-side APIs)
- `SUPABASE_JWT_SECRET` - Only needed for custom JWT verification

### ✅ Only 2 Required:
- `NEXT_PUBLIC_SUPABASE_URL` - Tells your app where Supabase is
- `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` - Public API key for auth/queries

---

## 📋 Verification Checklist

After setup, verify everything works:

1. ✅ Run `npm run dev` successfully
2. ✅ Navigate to [http://localhost:3000](http://localhost:3000)
3. ✅ See the homepage load
4. ✅ Try clicking "Sign In" - should load the auth page
5. ✅ Try creating an account (optional, but confirms Supabase connection works)

---

## 🚀 Next Steps After Local Setup

Based on the POC/MVP plan:

1. **Test the existing auth flow** - Make sure Supabase auth works
2. **Add Daily.co integration** - For voice recording (reference: no-bad-parts project)
3. **Create test flow pages** - Pre-test form → Instructions → Recording → Thank you
4. **Set up transcription** - Whisper API integration
5. **Build dashboard** - View completed tests

---

## 🛠 Troubleshooting

### "Missing environment variables" error
- Check `.env.local` exists in project root (not in a subfolder)
- Verify the values are correct (no extra quotes or spaces)
- Restart the dev server after creating `.env.local`

### Auth not working
- Verify `NEXT_PUBLIC_SUPABASE_URL` is correct
- Verify `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` matches the anon key from Vercel
- Check Supabase dashboard → Authentication → URL Configuration → Site URL includes `http://localhost:3000`

### Want to use Supabase locally?
- Follow [Supabase Local Development docs](https://supabase.com/docs/guides/getting-started/local-development)
- Use Supabase CLI to run locally
- Different environment variables needed for local Supabase instance

