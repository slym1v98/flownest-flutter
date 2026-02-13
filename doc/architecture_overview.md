# Architecture Overview

Kappa is designed to help you build Flutter applications following the **Clean Architecture** principles. This ensures your code is testable, maintainable, and decoupled from external dependencies.

## Key Principles

1.  **Independence of Frameworks:** The core business logic (Domain) doesn't depend on Flutter or any third-party libraries.
2.  **Testability:** Business rules can be tested without the UI, Database, Web Server, or any other external element.
3.  **Independence of UI:** The UI can change easily without changing the rest of the system.
4.  **Independence of Database:** You can swap out your database (e.g., from Hive to Sqflite) without affecting business logic.

## Dependency Rule

The primary rule in Clean Architecture is that **dependencies only point inwards**.

*   **Presentation Layer** depends on **Domain** and **Data**.
*   **Data Layer** depends on **Domain**.
*   **Domain Layer** is independent (or depends only on the **Core** layer).

```text
  [ Presentation ] ----> [ Domain ] <---- [ Data ]
          |                  ^              |
          +------------------+--------------+
                             |
                         [ Core ]
```

## How Kappa Helps

Kappa automates the boilerplate associated with Clean Architecture:

*   **CLI Generators**: Automatically creates the folders and files for each layer (`entity`, `repository`, `usecase`, `model`, `bloc`).
*   **Base Classes**: Cung cấp các lớp cơ sở như `BaseSimpleUseCase` (linh hoạt cho mọi kiểu trả về), `BaseRepositoryImpl`, và `BaseModel` để giảm thiểu code thừa.
*   **Initialization**: Xử lý việc thiết lập Service Locator (DI), Routing, và cấu hình môi trường phức tạp chỉ trong một lời gọi hàm duy nhất.

By using Kappa, you focus on writing the business logic while the framework ensures the architectural integrity of your project.
