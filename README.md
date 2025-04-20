# 📋 TechTask

TechTask is a Flutter-based task management application with email-based authentication using **Supabase** as the backend. The app allows users to securely log in or sign up using email, and manage their tasks by adding, updating, and deleting them. Each user sees only their own tasks.

---

## ✨ Features

- 🔐 **Secure Email Login & Sign-up**  
  Users can register and authenticate using their email credentials.

- ✅ **Task Management**  
  Users can:
  - Add new tasks with a title and description
  - Edit or update existing tasks
  - Delete tasks they no longer need
  - Mark tasks as completed (optional)

- 🔄 **Real-Time Sync with Supabase**  
  Tasks are stored and managed using Supabase, with real-time updates and secure access.

- 👤 **User-Specific Data Handling**  
  Each user’s tasks are private, with access controlled via Supabase Row-Level Security (RLS).

---

## 📁 Project Structure

- lib/ 
- ├── main.dart 
- ├── models/ 
- │ └── task_model.dart 
- ├── providers/ 
- │ └── auth_provider.dart 
- ├── services/ 
- │ └── supabase_service.dart 
- ├── screens/ 
-  │ ├── login_screen.dart 
-  │ ├── signup_screen.dart 
-  │ ├── dashboard_screen.dart 
- │ └── ... 
- └── widgets/ 
-  └── task_tile.dart



## 🛠️ Getting Started

Follow these steps to set up and run the TechTask project on your local machine.

### 1. Clone the Repository

bash
git clone https://github.com/your-username/TechTask.git
cd TechTask
### 2. Install Dependencies
Make sure you have Flutter installed. Then run:

bash
Copy
Edit
flutter pub get
### 3. Configure Supabase
#### a. Create a Supabase Project
Go to https://supabase.com and create a new project.

Once created, navigate to Project Settings > API and copy:

Project URL

anon public key

Paste these into your Flutter project (commonly in a constants file or .env using flutter_dotenv).

#### b. Create tasks Table
Inside the Supabase dashboard, create a new table named tasks with the following schema:


| Column Name | Type      | Description                        |
|-------------|-----------|------------------------------------|
| id          | UUID      | Primary key (default)              |
| user_id     | UUID      | Foreign key (from auth.users)      |
| title       | Text      | Title of the task                  |
| detail      | Text      | Description/detail of the task     |
| completed   | Boolean   | Task completion status             |
| created_at  | Timestamp | Timestamp when task was created    |

- Set Defaults:

id: gen_random_uuid()

created_at: now()

#### c. Enable Row-Level Security (RLS)
Go to the Table Editor > tasks > RLS

Enable RLS

#### d. Add Policy to Allow Authorized Users
Create the following policy:

sql
Copy
Edit
-- Select Policy
CREATE POLICY "Users can access their own tasks"
  ON public.tasks
  FOR ALL
  USING (auth.uid() = user_id);
This ensures only authenticated users can read or write their own tasks.

## 🚀 Run the App
Using VS Code:
Open the project folder.

Run flutter pub get if not already done.

Press F5 or click Run to start the app.

Using Android Studio:
Open the project.

Click the green Run button or use Run > Run ‘main.dart’.

## 🧪 Debugging Tips
Double-check your Supabase URL and anon key.

Check RLS policy if tasks are not loading.

Use flutter run -v for verbose output when debugging.


---

##  Hot Reload vs Hot Restart in Flutter

Understanding the difference between **Hot Reload** and **Hot Restart** is crucial for efficient Flutter development.

###  Hot Reload

- **What it does:**  
  Injects updated source code into the running Dart VM without requiring a full app restart.

- **Use case:**  
  When you change UI (widgets, themes, etc.) or logic inside methods, hot reload quickly reflects those changes without losing the current app state.

- **Benefits:**
  - Very fast
  - Preserves current app state (e.g., forms, navigation)
  - Great for iterative UI development

- **Limitations:**
  - Cannot reflect changes to `main()`, constructors, or global variables
  - May cause inconsistencies if state and code get out of sync

---

###  Hot Restart

- **What it does:**  
  Fully restarts the app by rebuilding the widget tree from scratch and reinitializing app state.

- **Use case:**  
  When you modify:
  - `main()` method
  - Global variables
  - Initial state of your app
  - Provider setups or app-wide logic

- **Benefits:**
  - Ensures a clean start with updated logic
  - Reflects changes that Hot Reload cannot apply

- **Drawbacks:**
  - Slower than hot reload
  - Resets the entire app state (e.g., logs out user, clears forms)

---

>  **Tip:** Use **Hot Reload** during layout and UI building for speed, and **Hot Restart** when changing configuration or state logic.


